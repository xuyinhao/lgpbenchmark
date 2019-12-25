package com.ls.loongoop.wordcount;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public class WordsDictionary {
    public static String DICTIONARY = "doc";
//    public static String GENRESUT_FILE_PATH = "/tmp/genresult/";
    public static String GENRESUT_FILE_PATH = "/tmp/wcgenresult";
//    public static String DEFAULT_FILE_PATH = "/datapool/wordscount/";
    private static List<String> words = new ArrayList();
    private static Properties properties = new Properties();
    public static String FILENAME_POSTFIX;
    public static String libPath;
    private static InputStream is;

    static  {
//        String path = WordsDictionary.class.getProtectionDomain().getCodeSource().getLocation().getPath();

//        libPath = path.substring(0, path.indexOf("lib")).replace("\\", "/");
//        setFilePath();
        source();
    }

    public static void setFilePath() {
        FileInputStream inputStream = null;
        File configFile = null;
        try { configFile = new File(libPath + "/wordcount/conf/config");
            inputStream = new FileInputStream(configFile);
            properties.load(inputStream);
            String filePath = properties.getProperty("filePath", "");
            String genResultPath = properties.getProperty("genResultPath", "");
//            if (!"".equals(filePath)) {
//                DEFAULT_FILE_PATH = filePath.endsWith("/") ? filePath : (filePath + "/");
//            }
            if (!"".equals(genResultPath)) {
                GENRESUT_FILE_PATH = genResultPath.endsWith("/") ? genResultPath : (genResultPath + "/");
            }
//            mkdir(new File(DEFAULT_FILE_PATH));
            mkdir(new File(GENRESUT_FILE_PATH)); }

        catch (FileNotFoundException e)

        {

            try { if (null != inputStream)
                inputStream.close();  }
            catch (IOException ea)
            { ea.printStackTrace(); }  }
            catch (IOException e)
            { try { if (null != inputStream) inputStream.close();  }
                catch (IOException ea) { ea.printStackTrace(); }  }
        finally { try { if (null != inputStream) inputStream.close();  } catch (IOException e) {} }

    }


    private static void mkdir(File file) {
        if (!file.exists()) {
            file.mkdir();
        }
    }

    public static void source() {
        InputStream is = WordsDictionary.class.getClassLoader().getResourceAsStream(DICTIONARY);
        BufferedReader reader = null;

        try { reader = new BufferedReader(new InputStreamReader(is));
            String tempString = null;
            while ((tempString = reader.readLine()) != null) {
                String[] attrs = tempString.split(" ");
                for (String string : attrs) {
                    words.add(string + " ");
                }
            }  }
        catch (IOException e) {  }
        finally
        { if (reader != null) {
            try {
                reader.close();
            } catch (IOException e1) {e1.printStackTrace();}
        } }

    }




    public static List<String> getDictionary() { return words; }
}
