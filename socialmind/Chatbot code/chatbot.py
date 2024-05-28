from flask import Flask, request, jsonify
import random
import json
import pickle
import numpy as np
import nltk
from nltk.stem import WordNetLemmatizer
from keras.models import load_model

app = Flask(__name__)

nltk.download('punkt')
nltk.download('wordnet')

lemmatizer = WordNetLemmatizer()

intents = json.loads(open(r'C:\Users\adhik\Desktop\Chatrobot\intent.json').read()) #aafno rakhne hai yo, keep your own path


words = pickle.load(open('words.pkl', 'rb'))
classes = pickle.load(open('classes.pkl', 'rb'))
model = load_model('chatbot_model.h5')

def clean_up_sentence(sentence):
    sentence_words = nltk.word_tokenize(sentence)
    sentence_words = [lemmatizer.lemmatize(word.lower()) for word in sentence_words]
    return sentence_words

def bag_of_words(sentence):
    sentence_words = clean_up_sentence(sentence)
    bag = [0] * len(words)
    for w in sentence_words:
        for i, word in enumerate(words):
            if word == w:
                bag[i] = 1
    return np.array(bag)

def predict_class(sentence):
    bow = bag_of_words(sentence)
    res = model.predict(np.array([bow]))[0]
    ERROR_THRESHOLD = 0.25
    results = [[i, r] for i, r in enumerate(res) if r > ERROR_THRESHOLD]
    results.sort(key=lambda x: x[1], reverse=True)
    return_list = []
    for r in results:
        return_list.append({'intent': classes[r[0]], 'probability': str(r[1])})
    return return_list

def get_response(intents_list, intents_json):
    if intents_list:
        tag = intents_list[0]['intent']
        list_of_intents = intents_json['intents']
        for i in list_of_intents:
            if i['tag'] == tag:
                result = random.choice(i['responses'])
                break
        return result
    else:
        return "Sorry, I didn't understand that."

print("GO! Bot is running!")
@app.route('/chatbot', methods=['POST'])
def chatbot_response():
    data = request.get_json()
    print("Received message:", data)  # Debugging print
    message = data['message']
    ints = predict_class(message)
    print("Predicted intents:", ints)  # Debugging print
    res = get_response(ints, intents)
    print("Response:", res)  # Debugging print
    return jsonify({"response": res})

if __name__ == "__main__":
    app.run(host="192.168.1.102", port=5000, debug=True)

#while True:
 #   message = input("")
 #   if message.lower() == "quit":
  #      break
  #  ints = predict_class(message)S
  #  res = get_response(ints, intents)
  #  print(res)
