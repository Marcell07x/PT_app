// Generates the public legal pages from the markdown documents in this folder.
//
//   dart run legal/build_site.dart
//
// Output goes to legal/site/, laid out as directories with index.html files so
// the clean URLs (/terms, /hu/feltetelek, ...) work on any static host without
// rewrite rules. Upload the *contents* of legal/site/ to the web root.
//
// The markdown here is hand-written and uses a small, known subset, so this
// converter only implements that subset rather than pulling in a dependency:
// headings, paragraphs, bold, inline code, links, autolinks, bullet and
// numbered lists, tables and horizontal rules.

import 'dart:io';

/// One published document: where its markdown lives, where it goes on the web,
/// and the title shown in the footer navigation.
class Doc {
    final String source;
    final String outPath;
    final String lang;
    final String navLabel;
    /// The same document in the other language.
    final String otherLangPath;

    const Doc({
        required this.source,
        required this.outPath,
        required this.lang,
        required this.navLabel,
        required this.otherLangPath,
    });
}

const List<Doc> docs = [
    Doc(
        source: 'legal/hu/felhasznalasi-feltetelek.md',
        outPath: 'hu/feltetelek',
        lang: 'hu',
        navLabel: 'Felhasználási feltételek',
        otherLangPath: '/terms/',
    ),
    Doc(
        source: 'legal/hu/egeszsegugyi-tajekoztato.md',
        outPath: 'hu/egeszseg',
        lang: 'hu',
        navLabel: 'Egészségügyi tájékoztató',
        otherLangPath: '/health/',
    ),
    Doc(
        source: 'legal/hu/adatvedelmi-tajekoztato.md',
        outPath: 'hu/adatvedelem',
        lang: 'hu',
        navLabel: 'Adatvédelem',
        otherLangPath: '/privacy/',
    ),
    Doc(
        source: 'legal/en/terms-of-use.md',
        outPath: 'terms',
        lang: 'en',
        navLabel: 'Terms of Use',
        otherLangPath: '/hu/feltetelek/',
    ),
    Doc(
        source: 'legal/en/health-disclaimer.md',
        outPath: 'health',
        lang: 'en',
        navLabel: 'Health Disclaimer',
        otherLangPath: '/hu/egeszseg/',
    ),
    Doc(
        source: 'legal/en/privacy-policy.md',
        outPath: 'privacy',
        lang: 'en',
        navLabel: 'Privacy Policy',
        otherLangPath: '/hu/adatvedelem/',
    ),
];

/// The documents cross-reference each other by relative markdown path; on the
/// web those have to become the published URLs.
const Map<String, String> linkRewrites = {
    './egeszsegugyi-tajekoztato.md': '/hu/egeszseg/',
    './adatvedelmi-tajekoztato.md': '/hu/adatvedelem/',
    './felhasznalasi-feltetelek.md': '/hu/feltetelek/',
    './health-disclaimer.md': '/health/',
    './privacy-policy.md': '/privacy/',
    './terms-of-use.md': '/terms/',
};

void main() {
    final outputRoot = Directory('legal/site');
    if (outputRoot.existsSync()) outputRoot.deleteSync(recursive: true);

    for (final doc in docs) {
        final file = File(doc.source);
        if (!file.existsSync()) {
            stderr.writeln('Missing source: ${doc.source}');
            exitCode = 1;
            return;
        }

        final markdown = file.readAsStringSync();
        final title = _firstHeading(markdown);
        final body = _renderBlocks(markdown);
        final html = _page(doc: doc, title: title, body: body);

        final target = File('legal/site/${doc.outPath}/index.html');
        target.parent.createSync(recursive: true);
        target.writeAsStringSync(html);
        stdout.writeln('${doc.outPath}/index.html  <-  ${doc.source}');
    }

    // The site root already served the privacy policy before these pages
    // existed, and that URL is what the app stores have on file as the privacy
    // policy link. Publishing the same document at the root keeps that link
    // working; the canonical tag points search engines at the real address.
    final rootDoc = docs.firstWhere((d) => d.outPath == 'privacy');
    final rootMarkdown = File(rootDoc.source).readAsStringSync();
    File('legal/site/index.html').writeAsStringSync(_page(
        doc: rootDoc,
        title: _firstHeading(rootMarkdown),
        body: _renderBlocks(rootMarkdown),
        canonical: 'https://getshap.com/privacy/',
    ));
    stdout.writeln('index.html  <-  ${rootDoc.source}  (root copy)');

    stdout.writeln('\nDone. Upload the contents of legal/site/ to the web root.');
}

String _firstHeading(String markdown) {
    for (final line in markdown.split('\n')) {
        if (line.startsWith('# ')) return line.substring(2).trim();
    }
    return 'GetShap';
}

// ---------------------------------------------------------------------------
// Block-level conversion
// ---------------------------------------------------------------------------

String _renderBlocks(String markdown) {
    final lines = markdown.replaceAll('\r\n', '\n').split('\n');
    final out = StringBuffer();
    var i = 0;

    while (i < lines.length) {
        final line = lines[i];
        final trimmed = line.trim();

        if (trimmed.isEmpty) {
            i++;
            continue;
        }

        if (trimmed == '---') {
            out.writeln('<hr>');
            i++;
            continue;
        }

        if (trimmed.startsWith('#')) {
            final level = trimmed.split(' ').first.length;
            final text = trimmed.substring(level).trim();
            // The document's own H1 is rendered by the page template, so it is
            // skipped here to avoid printing the title twice.
            if (level > 1) {
                out.writeln('<h$level>${_inline(text)}</h$level>');
            }
            i++;
            continue;
        }

        if (trimmed.startsWith('>')) {
            final quoted = <String>[];
            while (i < lines.length && lines[i].trim().startsWith('>')) {
                quoted.add(lines[i].trim().substring(1).trim());
                i++;
            }
            out.writeln('<blockquote>${_inline(quoted.join(' '))}</blockquote>');
            continue;
        }

        if (trimmed.startsWith('|')) {
            final table = <String>[];
            while (i < lines.length && lines[i].trim().startsWith('|')) {
                table.add(lines[i].trim());
                i++;
            }
            out.writeln(_renderTable(table));
            continue;
        }

        if (_isBullet(trimmed) || _isNumbered(trimmed)) {
            final ordered = _isNumbered(trimmed);
            final items = <String>[];
            while (i < lines.length) {
                final current = lines[i];
                final currentTrimmed = current.trim();
                if (currentTrimmed.isEmpty) break;
                if (_isBullet(currentTrimmed) || _isNumbered(currentTrimmed)) {
                    items.add(_stripMarker(currentTrimmed));
                } else if (items.isNotEmpty) {
                    // Wrapped continuation of the previous item.
                    items[items.length - 1] += ' $currentTrimmed';
                } else {
                    break;
                }
                i++;
            }
            final tag = ordered ? 'ol' : 'ul';
            out.writeln('<$tag>');
            for (final item in items) {
                out.writeln('<li>${_inline(item)}</li>');
            }
            out.writeln('</$tag>');
            continue;
        }

        // Plain paragraph: join the hard-wrapped lines back together.
        final paragraph = <String>[];
        while (i < lines.length) {
            final current = lines[i].trim();
            if (current.isEmpty ||
                current == '---' ||
                current.startsWith('#') ||
                current.startsWith('|') ||
                current.startsWith('>') ||
                _isBullet(current) ||
                _isNumbered(current)) {
                break;
            }
            paragraph.add(current);
            i++;
        }
        out.writeln('<p>${_inline(paragraph.join(' '))}</p>');
    }

    return out.toString();
}

bool _isBullet(String line) => line.startsWith('- ') || line.startsWith('* ');

bool _isNumbered(String line) => RegExp(r'^\d+\.\s').hasMatch(line);

String _stripMarker(String line) {
    if (_isBullet(line)) return line.substring(2).trim();
    return line.replaceFirst(RegExp(r'^\d+\.\s+'), '').trim();
}

String _renderTable(List<String> rows) {
    List<String> cells(String row) {
        var trimmed = row;
        if (trimmed.startsWith('|')) trimmed = trimmed.substring(1);
        if (trimmed.endsWith('|')) {
            trimmed = trimmed.substring(0, trimmed.length - 1);
        }
        return trimmed.split('|').map((c) => c.trim()).toList();
    }

    bool isSeparator(String row) =>
        RegExp(r'^\|[\s:\-|]+\|?$').hasMatch(row) && row.contains('-');

    final out = StringBuffer('<div class="table-wrap"><table>');
    var wroteHeader = false;

    for (var index = 0; index < rows.length; index++) {
        final row = rows[index];
        if (isSeparator(row)) continue;

        final isHeader = index == 0 &&
            rows.length > 1 &&
            isSeparator(rows[1]);
        final tag = isHeader ? 'th' : 'td';

        if (isHeader) {
            out.write('<thead>');
            wroteHeader = true;
        } else if (wroteHeader) {
            out.write('<tbody>');
            wroteHeader = false;
        }

        out.write('<tr>');
        for (final cell in cells(row)) {
            out.write('<$tag>${_inline(cell)}</$tag>');
        }
        out.write('</tr>');

        if (isHeader) out.write('</thead>');
    }

    out.write('</tbody></table></div>');
    return out.toString();
}

// ---------------------------------------------------------------------------
// Inline conversion
// ---------------------------------------------------------------------------

String _inline(String text) {
    // Escape first, so anything in the source is inert; the patterns below then
    // match against the escaped form (autolinks become &lt;...&gt;).
    var result = text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');

    result = result.replaceAllMapped(
        RegExp(r'`([^`]+)`'),
        (m) => '<code>${m[1]}</code>',
    );

    result = result.replaceAllMapped(
        RegExp(r'\[([^\]]+)\]\(([^)]+)\)'),
        (m) {
            final href = linkRewrites[m[2]] ?? m[2]!;
            return '<a href="$href">${m[1]}</a>';
        },
    );

    result = result.replaceAllMapped(
        RegExp(r'&lt;(https?://[^&\s]+)&gt;'),
        (m) => '<a href="${m[1]}">${m[1]}</a>',
    );

    result = result.replaceAllMapped(
        RegExp(r'\*\*([^*]+)\*\*'),
        (m) => '<strong>${m[1]}</strong>',
    );

    return result;
}

// ---------------------------------------------------------------------------
// Page template
// ---------------------------------------------------------------------------

String _page({
    required Doc doc,
    required String title,
    required String body,
    String? canonical,
}) {
    final siblings = docs.where((d) => d.lang == doc.lang && d != doc);
    final otherLangLabel = doc.lang == 'hu' ? 'English' : 'Magyar';
    final backLabel = doc.lang == 'hu' ? 'GetShap' : 'GetShap';

    final navLinks = siblings
        .map((d) => '<a href="/${d.outPath}/">${d.navLabel}</a>')
        .join('\n            ');

    return '''<!doctype html>
<html lang="${doc.lang}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$title</title>
${canonical == null ? '' : '<link rel="canonical" href="$canonical">'}
<style>
:root {
    --blue: #2E6BF0;
    --text: #1c1e21;
    --muted: #5b6470;
    --line: #e2e5ea;
    --bg: #ffffff;
    --card: #f7f8fa;
}
@media (prefers-color-scheme: dark) {
    :root {
        --text: #e8eaed;
        --muted: #a3abb6;
        --line: #333a44;
        --bg: #16181c;
        --card: #1e2127;
    }
}
* { box-sizing: border-box; }
body {
    margin: 0;
    background: var(--bg);
    color: var(--text);
    font: 16px/1.65 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
    -webkit-text-size-adjust: 100%;
}
.wrap { max-width: 760px; margin: 0 auto; padding: 0 20px 64px; }
header {
    background: var(--blue);
    padding: 22px 20px;
    margin-bottom: 36px;
}
header .inner {
    max-width: 760px;
    margin: 0 auto;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
}
header a { color: #fff; text-decoration: none; }
header .brand { font-size: 21px; font-weight: 800; letter-spacing: .3px; }
header .lang {
    font-size: 14px;
    border: 1px solid rgba(255,255,255,.55);
    border-radius: 999px;
    padding: 4px 12px;
    white-space: nowrap;
}
h1 { font-size: 30px; line-height: 1.25; margin: 0 0 8px; }
h2 { font-size: 20px; margin: 38px 0 10px; }
h3 { font-size: 17px; margin: 28px 0 8px; }
p, li { color: var(--text); }
a { color: var(--blue); }
ul, ol { padding-left: 22px; }
li { margin: 6px 0; }
hr { border: 0; border-top: 1px solid var(--line); margin: 34px 0; }
blockquote {
    margin: 22px 0;
    padding: 16px 18px;
    background: var(--card);
    border-left: 4px solid var(--blue);
    border-radius: 6px;
}
code {
    background: var(--card);
    padding: 1px 5px;
    border-radius: 4px;
    font-size: 14px;
}
.table-wrap { overflow-x: auto; margin: 16px 0; }
table { border-collapse: collapse; width: 100%; font-size: 15px; }
th, td {
    border: 1px solid var(--line);
    padding: 9px 12px;
    text-align: left;
    vertical-align: top;
}
th { background: var(--card); font-weight: 600; }
footer {
    margin-top: 52px;
    padding-top: 22px;
    border-top: 1px solid var(--line);
    font-size: 15px;
    color: var(--muted);
}
footer a { display: inline-block; margin-right: 18px; }
</style>
</head>
<body>
<header>
    <div class="inner">
        <a class="brand" href="/">$backLabel</a>
        <a class="lang" href="${doc.otherLangPath}">$otherLangLabel</a>
    </div>
</header>
<div class="wrap">
    <h1>$title</h1>
$body
    <footer>
            $navLinks
    </footer>
</div>
</body>
</html>
''';
}
