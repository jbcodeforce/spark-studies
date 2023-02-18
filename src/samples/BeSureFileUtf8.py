import codecs


with codecs.open("../data/movielens/u.item", "r") as sourceFile:
    with codecs.open("../data/movielens/u.item2", "w", "utf-8") as targetFile:
        while True:
            try :
                contents = sourceFile.read(7000)
                print(contents)
                if not contents:
                    break
                targetFile.write(contents)
            except UnicodeDecodeError:
                print("error but skip line")