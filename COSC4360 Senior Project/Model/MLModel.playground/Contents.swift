import Cocoa
import CreateML

// import our data
let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/miguelbarajas/Downloads/twitter-sanders-apple3.csv"))

// split our data: 80% training, 20% testing
let(trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)

// create the ml model
let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

// testing
let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")
let evaluationAccuracy = (1 - evaluationMetrics.classificationError) * 100

// metadata
let metadata = MLModelMetadata(author: "Miguel Barajas, Michael Palanog, Kevin Comaduran, Mashal Khan", shortDescription: "ML Model to classify the sentiment in text", version: "1.0")

// save it to some location
try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/miguelbarajas/Desktop/TweetSentimentClassifer.mlmodel"), metadata: metadata)
