package com.ls.loongoop.wordcount;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;

public class WordsCheck {
    public void wordsCheck() {
        long[] counts = genResult();
        checkResult(counts);
    }

    private long[] genResult() {
        int size = WordsDictionary.getDictionary().size();
        File genDir = new File(WordsDictionary.GENRESUT_FILE_PATH);
        long[] gencounts = new long[size];
        File[] genFiles = genDir.listFiles();
        BufferedReader reader = null;
        for (File file : genFiles) {

            try { reader = new BufferedReader(new FileReader(file));
                String str = null;
                int i = 0;
                while ((str = reader.readLine()) != null) {
                    if (!"".equals(str)) {
                        String[] strs = str.split(" ");
                        gencounts[i] = gencounts[i] + Long.parseLong(strs[1]);
                        i++;
                    }
                }



                if (null != reader)

                    try { reader.close(); }
                    catch (IOException e) { e.printStackTrace(); }
                    } catch (IOException e) { e.printStackTrace(); }
                finally
            { if (null != reader) try { reader.close(); } catch (IOException e) {}
            }

        }

        return gencounts;
    }

    private void checkResult(long[] counts) {
        List<String> words = WordsDictionary.getDictionary();
        File file = new File(WordsDictionary.libPath + "/wordcount/output");
       BufferedReader reader = null;
        boolean flag = true;
        try {
            reader = new BufferedReader(new FileReader(file));
            String tmp = null;
            while ((tmp = reader.readLine()) != null) {
                String str = tmp.substring(0, tmp.indexOf("\t")) + " ";
                String c = tmp.substring(tmp.lastIndexOf("\t") + 1, tmp.length());
                long num = Long.valueOf(c).longValue();
                int index = words.indexOf(str);
                if (-1 != index && counts[index] != num) {
                    flag = false;
                }
            }
        } catch (IOException e) {
            flag = false;
        } finally {
            if (null != reader) {
                try {
                    reader.close();
                } catch (IOException e) {}
            }
        }

        if (flag) {
            System.out.println("loongoop wordcount is correct!");
        } else {
            System.out.println("loongoop wordcount is incorrect!");
        }
    }
}
