package com.ls.loongoop.wordcount;

import com.ls.loongoop.util.FileUtil;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


public class WordsWriteService
{
    public void writeWords(long totalSize, int fileNum, int eachNum, int nodeIndex, String genWordsPath) {
        ExecutorService executor = Executors.newFixedThreadPool(10);
        long fileSize = totalSize / fileNum;
        CountDownLatch doneSignal = new CountDownLatch(fileNum);
        List<WordsFileGen> fileGens = new ArrayList<WordsFileGen>();
        for (int i = 0; i < fileNum; i++) {
            WordsFileGen wordsFileGen = new WordsFileGen("/words" + nodeIndex + i, fileSize, eachNum,genWordsPath, doneSignal);

            executor.execute(wordsFileGen);
            fileGens.add(wordsFileGen);
        }
        try {
            doneSignal.await();
        } catch (InterruptedException i) {
            InterruptedException e;
        }  writeCounts(fileGens, nodeIndex);
        executor.shutdown();
    }

    public static void writeCounts(List<WordsFileGen> fileGens, int nodeIndex) {
        File file = new File(WordsDictionary.GENRESUT_FILE_PATH + "gen" + nodeIndex);
        if (file.exists()) {
            file.delete();
        }
        List<String> words = WordsDictionary.getDictionary();
        int[] counts = new int[words.size()];
        for (WordsFileGen fileGen : fileGens) {
            int[] wordscount = fileGen.getWordsCount();
            for (int i = 0; i < wordscount.length; i++) {
                counts[i] = counts[i] + wordscount[i];
            }
        }
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < counts.length; i++) {
            int count = counts[i];
            String word = (String)words.get(i);
            sb.append(word + count + "\n");
        }
        try {
            FileUtil.writeFile(file, sb.toString(), true);
        } catch (IOException i) {
            IOException e;
        }
    }
}
