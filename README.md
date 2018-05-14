# Tokenizer

This is a Praat plug-in which segments TextGrid annotations into segments, syllables or words. 
The resulting segmentation is stored as a new tier whithin the same TextGrid.

## Getting started

### Prerequisites

- Praat 6.0.40 or la (download [here](http://www.fon.hum.uva.nl/praat/download_win.html))

### Install

### Set-up

In the Object window, go to `Praat > Tokenize > Settings...`, a dialog box will appear. 

<img src="/uploads/74cdb6a7496cb2c3e3eb8a53613b99ad/Screenshot_from_2017-12-06_22-15-53.png" width="40%">

### How to use it?

Once you are done with the settings, you are ready to process your own TextGrids.
Before starting, remember that you need to provide an interval tier as an input for this plug-in to work. Here is an example.

<img src="/uploads/919d0228a12ac452dcd68b9a5e264626/004.png" width="50%">

With this plug-in, you can segment TextGrids in the Object window and those stored in a folder.

#### From the Object window...

First, select those TextGrids that you want to segment. Then, go to `TextGrid: Add tokenized tier...`

<img src="/uploads/c1337f0256791b8c9958c349e80c15db/002.png" width="30%">

When you click on it, you will see a dialog box. In `Input tier`, write the name of the tier where your annotations are stored. 
Then, check the segmentation levels to be be generated. Finally, press on **Apply** or **Ok**. The TexGrids are now segmented!

![Screenshot_from_2017-12-06_23-17-36](/uploads/10b5682dee9526f6c8ef5559f1b45575/Screenshot_from_2017-12-06_23-17-36.png)

#### From a folder...

In the Praat menu, go to `Praat > Tokenizer > Tokenize(do all)...` 
You will see a dialog box similar to one shown in the previous case. 
In the `Folder with annotation files` put the directory where your TextGrids are located in your machine.
In `Save results in`, copy the path where the resulting files will be stored.
Then, complete the other fields as explained before and press on **Apply** or **Ok**. The resulting files should be in the destiny directory.

![Screenshot_from_2017-12-06_23-12-53](/uploads/573194ae73c7ba9beac1a298b9598b32/Screenshot_from_2017-12-06_23-12-53.png)

## Author

- Rolando Muñoz Aramburú

## License

This project is licensed under the GNU GPL terms - see the [LICENSE.md](https://gitlab.com/praat_plugins_rma/plugin_tokenizer/blob/master/LICENSE)
 file for details.

## How to cite?

`Muñoz A., Rolando (2018). Tokenizer[Praat plug-in]. Version 1.0.1, retrived 14 May 2018 from https://gitlab.com/praat_plugins_rma/plugin_tokenizer`
