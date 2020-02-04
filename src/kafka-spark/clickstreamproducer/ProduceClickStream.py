import KafkaProducer as kafkaProducer

def produceClickEvent(eventAsString):
    print(eventAsString)
    kafkaProducer.publishEvent("TestTopic",eventAsString,"")

def loadClickData():
    print("Load click data from file")
    with open('../../../data/access_log.txt') as f:
        for line in f:
            produceClickEvent(line)

if __name__ == "__main__":
    print("Let simulate some clicks done on a website")
    loadClickData()