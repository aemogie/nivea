#!/usr/bin/env bash
set -euo pipefail
set -x

device="$1"
subvol="$2"
subvolFlat="${subvol//\//_}"

mnt=$(mktemp -d)
mount "$device" "$mnt"

# get snapshot
if [[ -e "$mnt/$subvol" ]]; then
    # backup
    last_modified=$(stat -c %Y "$mnt/$subvol")
    timestamp=$(date --date="@$last_modified" "+%Y-%m-%-d_%H:%M:%S")
    snapshot="@snapshots/${subvolFlat}/$timestamp"
    [[ -d "$mnt/@snapshots" ]] || btrfs subvolume create "$mnt/@snapshots"
    [[ -d "$(dirname "$mnt/$snapshot")" ]] || btrfs subvolume create "$(dirname "$mnt/$snapshot")"
    mv "$mnt/$subvol" "$mnt/$snapshot"
    # recreate
    btrfs subvolume create "$mnt/$subvol"
    # resurrect children
    while read _ id _ gen _ _ top_level _ path; do
	dest="$mnt/$subvol/${path##$snapshot/}"
	mkdir -p "$(dirname "$dest")"
	mv "$mnt/$path" "$dest"
    done < <(btrfs subvolume list -o "$mnt/$snapshot")
fi

while read dir; do
    [[ -z "$(btrfs subvolume list -o "$dir")" ]] || {
	echo "error: snapshot '$dir' retains subvolumes that were not resurrected" >&2
	continue
    }
    btrfs subvolume delete "$dir"
done < <(find "$mnt/@snapshots/${subvolFlat}" -mindepth 1 -maxdepth 1 -mtime +30 2>/dev/null || true)

umount "$mnt"
rmdir "$mnt"
