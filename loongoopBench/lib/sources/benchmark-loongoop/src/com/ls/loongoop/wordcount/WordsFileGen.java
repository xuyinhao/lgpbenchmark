package com.ls.loongoop.wordcount;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Random;
import java.util.concurrent.CountDownLatch;

public class WordsFileGen implements Runnable {
    private String fileName;
    private long fileSize;
    private int eachNum;
    private int size;
    private  String genWordsPath;
    private CountDownLatch doneSignal;
    private Random random = new Random();

    private List<String> words;

    private int[] wordsCount;


    public WordsFileGen() {}

    public WordsFileGen(String fileName, long fileSize, int eachNum, String genWordsPath,CountDownLatch doneSignal) {
        this.fileName = fileName;
        this.genWordsPath= genWordsPath;
        this.fileSize = fileSize;
        this.eachNum = eachNum;
        this.doneSignal = doneSignal;
        this.words = WordsDictionary.getDictionary();
        this.size = this.words.size();
        this.wordsCount = new int[this.size];
    }


    public void run() {
        writeWords();
        this.doneSignal.countDown();
    }

    public void writeWords() {
        File file = new File( this.genWordsPath+ this.fileName);
        if (file.exists()) {
            file.delete();
        }
        long len = 0L;
        DataOutputStream dos = null;

        try { dos = new DataOutputStream(new FileOutputStream(file));
            while (len <= this.fileSize) {
                StringBuffer sb = new StringBuffer();
                for (int i = 0; i < this.eachNum; i++) {
                    int index = this.random.nextInt(this.size - 1);
                    String word = (String)this.words.get(index);
                    sb.append(word);
                    wordsCount(index);
                }
//                System.out.println(System.getProperty("line.separator"));
//                sb.append("\n");
//                sb.append(System.getProperty("line.separator"));
                dos.write(System.getProperty("line.separator").getBytes());
                dos.write(sb.toString().getBytes());
                len += sb.toString().getBytes().length;
            }  }
        catch (IOException e) {  }
        finally
        { if (null != dos) {
            try {
                dos.close();
            } catch (IOException e) {}
        } }

    }



    public void wordsCount(int index) { this.wordsCount[index] = this.wordsCount[index] + 1; }



    public int[] getWordsCount() { return this.wordsCount; }
}
