# Meduza Roboter

A small shell script to fetch Meduza RSS feed, save the news as text files, and optionally process text to voice.

### How to use it

The script requires the following dependencies:

`xmlstarlet python-html2text curl`

Text-to-speech engine is also required: `espeak-ng`

### To fetch the latest news

Simply run

`bash meduzaroboter.sh`

If you don't want any **voice processing**, then just add an argument:

`bash meduzaroboter.sh --novoice`

You'll find your text articles in `meduza_articles_text` subdirectory, same with machine voice recordings: `meduza_articles_voice`

### What if Meduza is blocked?

Don't worry, just pass an HTTP Proxy setting to the script:

`http_proxy="http://127.0.0.1:8118" bash meduzaroboter.sh`

## What is Meduza?

[Meduza](https://meduza.io/en) is a Russian independent news agency, that the Russian government first blocked for its honest covering of the ongoing war in Ukraine, and recently it became a "non-desirable" organization in Russia, hence it is now forbidden to [even mention it in public](https://meduza.io/en/cards/life-after-undesirability). You can [**❤️  donate them**](https://support.meduza.io/en) and support their enormous work against the harsh and barbaric Russian regime. The script is based on the English version of the outlet.
