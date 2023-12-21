#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Safety settings (see https://gist.github.com/ilg-ul/383869cbb01f61a51c4d).

if [[ ! -z ${DEBUG} ]]
then
  set ${DEBUG} # Activate the expand mode if DEBUG is anything but empty.
else
  DEBUG=""
fi

set -o errexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if variable not set.

# Remove the initial space and instead use '\n'.
IFS=$'\n\t'

# -----------------------------------------------------------------------------
# Identify the script location, to reach, for example, the helper scripts.

script_path="$0"
if [[ "${script_path}" != /* ]]
then
  # Make relative path absolute.
  script_path="$(pwd)/$0"
fi

script_name="$(basename "${script_path}")"

script_folder_path="$(dirname "${script_path}")"
script_folder_name="$(basename "${script_folder_path}")"

# =============================================================================

authors="${CRONICA_IT_AUTHORS:-"ilg-ul"}"
tags="${CRONICA_IT_TAGS:-""}"
links="${CRONICA_IT_LINKS:-"- TODO"}"

blog_folder_path="$(dirname "${script_folder_path}")/website/blog"

# -----------------------------------------------------------------------------

blog_post_year=$(date +%Y)
# echo $blog_post_year

echo -n "slug: "
read slug

blog_post_folder_name="${blog_post_year}-${slug}"

if [ -d "${blog_folder_path}/${blog_post_folder_name}" ]
then
  echo "folder ${blog_folder_path}/${blog_post_folder_name} already in use"
  exit 1
fi

if [ -f "${blog_folder_path}/${blog_post_folder_name}.md" ]
then
  echo "file ${blog_folder_path}/${blog_post_folder_name}.md already in use"
  exit 1
fi

date="$(date -u '+%Y-%m-%dT%H:%M:%S')"

tmp_file_path="$(dirname "${script_folder_path}")/${blog_post_folder_name}.md.tmp"

touch "${tmp_file_path}"

echo "---" >>"${tmp_file_path}"
echo "slug: ${blog_post_year}/${slug}" >>"${tmp_file_path}"
echo "title: 'TODO'" >>"${tmp_file_path}"
echo "authors: [${authors}]" >>"${tmp_file_path}"
echo "tags: [${tags}]" >>"${tmp_file_path}"
echo "date: ${date}" >>"${tmp_file_path}"
echo >>"${tmp_file_path}"
echo "---" >>"${tmp_file_path}"
echo >>"${tmp_file_path}"
echo "TODO" >>"${tmp_file_path}"
echo >>"${tmp_file_path}"
echo "<!-- truncate -->" >>"${tmp_file_path}"
echo >>"${tmp_file_path}"
echo "---" >>"${tmp_file_path}"
echo >>"${tmp_file_path}"
echo "TODO" >>"${tmp_file_path}"
echo >>"${tmp_file_path}"
echo "## Referințe" >>"${tmp_file_path}"
echo >>"${tmp_file_path}"

echo "${links}" >>"${tmp_file_path}"

index_file_path="${blog_folder_path}/${blog_post_folder_name}/index.md"

mkdir -p "${blog_folder_path}/${blog_post_folder_name}"
mv "${tmp_file_path}" "${index_file_path}"

echo "Blog post ${blog_post_year}-${slug} created"

# -----------------------------------------------------------------------------

