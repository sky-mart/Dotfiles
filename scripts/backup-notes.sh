#!/usr/bin/env sh

restic --insecure-no-password -r backups/notes backup ~/notes
