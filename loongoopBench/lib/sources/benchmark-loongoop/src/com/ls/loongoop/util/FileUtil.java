package com.ls.loongoop.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class FileUtil
{
    public static List<String> readFileToList(File file) {
        List<String> content = new ArrayList<String>();
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader(file));
            String tempString = null;
            while ((tempString = reader.readLine()) != null) {
                content.add(tempString);
            }
            return content;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e1) {}
            }
        }
    }


    public static void writeFile(File file, String content, boolean isAppend) throws IOException {
        FileWriter writer = null;
        try {
            writer = new FileWriter(file, isAppend);
            writer.write(content);
            writer.flush();
        } finally {
            try {
                writer.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
