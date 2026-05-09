#!/bin/sh

# Define the output directory (where the website files will go)
OUTPUT_DIR="zig-0.16.0-standard-lib-sources"
mkdir -p "$OUTPUT_DIR"

# Find all .zig files recursively
find . -type f -name "*.zig" | while read -r zig_file; do
    # Remove the leading './' and create the same folder structure in dist
    rel_path="${zig_file#./}"
    html_file="$OUTPUT_DIR/${rel_path}.html"
    mkdir -p "$(dirname "$html_file")"

    echo "Processing $rel_path..."

    # Create the HTML wrapper
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
    </style>
</head>
<body>
    <div class="header">
        <a href="/">Index</a> | <strong>File: $rel_path</strong>
    </div>
    <pre>$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' "$zig_file")</pre>
</body>
</html>
EOF
done

echo "Done! Your site is in the /$OUTPUT_DIR folder."
