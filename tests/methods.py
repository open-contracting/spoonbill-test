import polib


def get_translate_by_text_from_file(file_path, text):
    pofile = polib.pofile(file_path)
    text = text.strip()
    for entry in pofile:
        if text == entry.msgid:
            return entry.msgstr
