# JAWS Settings for LUWRAIN Application

Application settings that automatically enable JAWS sleep mode in a window of LUWRAIN self-voicing application.

## Package contents

* help*.html: Help files. There is the main english help.html file, as well as its translations, for example, help_ru.html in Russian.
* install*.vbs: Automatic installation script files. There is the main install.vbs file, as well as its localizers, for example, install_ru.vbs for installation in Russian.
* LICENSE.txt: File with the license text of install*.vbs scripts.
* luwrain*.JCF: JAWS application settings files for LUWRAIN (CONFIG File Type). There is the luwrain.JCF file for the LUWRAIN application running with the embedded JRE, as well as its analogues for the LUWRAIN application running with the locally installed JRE, for example, luwrain-base.JCF if an executable JAR file with the main class is called luwrain-base.jar.
* README.md: This file.
* style.css: A common cascading style sheets file for HTML help files.

## Localizing

To localize the package in new languages, you need to create a new script localizer and translate the help file.
It is advisable to send the created new localizations as a pull request to the upstream repository where this package is located.

### Creating a new script localizer

1. Create a copy of an existing script localizer, for example, the Russian install_ru.vbs script.
2. Name the new script localizer using the target language, for example, install_es.vbs for Spanish. Use commonly understood language designations, such as language codes of the ISO 639.
3. Open the new script localizer file in an editor and translate the string values of all variables whose names begin with "msg" into the target language.  
Please note the following:
    * It is recommended to save the script localizer file in UTF-16 Little Endian (with BOM) encoding to ensure Unicode support.
    * Variables with translatable message strings begin after the comment line "Translatable message strings".
    * Above each line of a Variable with translatable message string there is a comment line with the English text of the message.
    * The code starting with the RunInstallation() procedure call does not need to be localization. It should be left as is.

### Translation of the help file 

1. Create a copy of an existing help file, for example, the main english help.html file.
2. Name the new help file using the target language, for example, help_es.vbs for Spanish. Use commonly understood language designations, such as language codes of the ISO 639.
3. Open the new help file in an editor and translate its contents as a regular document in HTML format.  
Please note the following:
    * The Help file should be saved in UTF-8 (without BOM) encoding.
    * In the lang attribute of the &lt;html&gt; tag, change the value to the target language code according to the ISO 639 standard.
