#!/bin/sh
# Parse options
source_dir="."
while getopts "s:" opt; do
    case $opt in
        s) source_dir="$OPTARG" ;;
        *) echo "Usage: $0 [-s source_dir] [output_dir]"; exit 1 ;;
    esac
done
shift $((OPTIND - 1))
# 1st positional argument as output dir, default to current dir
output_dir="${1:-.}"
mkdir -p "$output_dir"
# Find all .zig files recursively under source_dir
find "$source_dir" -type f -name "*.zig" | while read -r zig_file; do
    # Remove the leading source_dir prefix
    rel_path="${zig_file#"$source_dir/"}"
    html_file="$output_dir/${rel_path}.html"
    mkdir -p "$(dirname "$html_file")"
    echo "Processing $rel_path..."
    cat <<EOF > "$html_file"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Source: $rel_path</title>
    <style>
        body { background: #1e1e1e; color: #d4d4d4; font-family: monospace; padding: 20px; }
        pre { white-space: pre-wrap; word-wrap: break-word; }
        .header { border-bottom: 1px solid #444; padding-bottom: 10px; margin-bottom: 20px; }
        a { color: #569cd6; }
        a[id] { color: inherit; text-decoration: none; }
        :target { background: #3a3a00; }
    </style>
</head>
<body>
    <div class="header">
        <a href="/">Index</a> | <strong>File: $rel_path</strong>
    </div>
    <pre>$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' "$zig_file" | \
awk '{printf "<a id=\"L%d\"></a>%s\n", NR, $0}')
</pre>
</body>
</html>
EOF
done
echo "Done! Output is in $output_dir"
