package com.ls.loongoop;

import com.ls.loongoop.wordcount.WordsCheck;
import com.ls.loongoop.wordcount.WordsDictionary;
import com.ls.loongoop.wordcount.WordsWriteService;
import java.io.File;

public class Launcher
{
    public static void main(String[] args) throws Exception {
        if (args.length >= 1) {
            WordsCheck wordsCheck; String cmd = args[0];
            switch (cmd) {
                case "wordswrite":
                    if (args.length == 6) {
                        WordsWriteService wordsWriteService = new WordsWriteService();
                        long total = Long.parseLong(args[1]);
                        int fileNum = Integer.parseInt(args[2]);
                        int eachNum = Integer.parseInt(args[3]);
                        int nodeIndex = Integer.parseInt(args[4]);
                        String genWordsPath = new String(args[5]);
                        wordsWriteService.writeWords(total, fileNum, eachNum, nodeIndex,genWordsPath);
                    } else {
                        printUsage();
                    }
                    return;
                case "createpath":
                    String genWordsPath = new String(args[1]);
                    createPath(genWordsPath);
                    return;
                case "wordscheck":
                    wordsCheck = new WordsCheck();
                    wordsCheck.wordsCheck();
                    return;
            }
            printUsage();
        }
        else {

            printUsage();
        }
    }

    public static void createPath(String genWordsPath) {
        File filePath = new File(genWordsPath);
        if (!filePath.exists()) {
            filePath.mkdir();
        } else {
            File[] files = filePath.listFiles();
            for (File file : files) {
                file.delete();
            }
        }
    }


    private static void printUsage() { System.out.println("usage: \nwordswrite totalSize fileNum words index fileDirPath\ncreatepath dirPath \nwordscheck"); }
}
