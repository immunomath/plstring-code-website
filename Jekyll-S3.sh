#!/bin/sh

# Original script:  https://gist.github.com/imkarthikk/2fe9053f0aef275f5527
# Run it from the root of your Jekyll site like bash Jekyll-S3.sh

# This script uses the AWS command line interface (CLI) tool to upload content
# to S3.  The okta-awscli tool can be set up to get temporary credentials for
# use by the AWS CLI.
#
# For details about using okta-awscli with the AWS CLI, see also:
# https://confluence.nmdp.org/display/BIO/AWS+CLI+access+with+Okta+%28with+MFA%29+-+BIO+and+GDR
#
# E.g.
# brew install okta-awscli
# brew install awscli
# (define [bio] and [gdr] profiles in ~/.okta-aws)
# okta-awscli --okta-profile bio --profile bio
# aws --profile bio <awscli command>

##
# Configuration options
##
STAGING_BUCKET='s3://plstring-org-staging'
LIVE_BUCKET='s3://plstring.org'
SITE_DIR='_site/'
AWS_S3_CMD='aws --profile bio s3'

##
# Usage
##
usage() {
cat << _EOF_
Usage: ${0} [staging | live]
    
    staging		Deploy to the staging bucket
    live		Deploy to the live (www) bucket
_EOF_
}
 
##
# Color stuff
##
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)

function red() {
    echo "$RED$*$NORMAL"
}

function green() {
    echo "$GREEN$*$NORMAL"
}

function yellow() {
    echo "$YELLOW$*$NORMAL"
}

##
# Actual script
##

# Expecting at least 1 parameter
if [[ "$#" -ne "1" ]]; then
    echo "Expected 1 argument, got $#" >&2
    usage
    exit 2
fi

if [[ "$1" = "live" ]]; then
	BUCKET=$LIVE_BUCKET
	green 'Deploying to live bucket'
else
	BUCKET=$STAGING_BUCKET
	green 'Deploying to staging bucket'
fi


yellow '--> Running Jekyll'
bundle exec jekyll build \
|| { red '--> Jekyll build failed' ; exit 3 ; }


yellow '--> Gzipping all html, css and js files'
find $SITE_DIR \( -iname '*.html' -o -iname '*.css' -o -iname '*.js' \) -exec gzip -9 -n {} \; -exec mv {}.gz {} \; \
|| { red '--> Gzipping failed' ; exit 3 ; }

# Sync css files (Cache: 4 hours)
yellow '--> Uploading css files'
${AWS_S3_CMD} sync --exclude '*.*' --include '*.css' --content-type 'text/css' --cache-control 'max-age=14400' --content-encoding 'gzip' $SITE_DIR $BUCKET \
|| { red '--> css upload failed' ; exit 4 ; }

# Sync js files (Cache: 4 hours)
yellow '--> Uploading js files'
${AWS_S3_CMD} sync --exclude '*.*' --include '*.js' --content-type 'application/javascript' --cache-control 'max-age=14400' --content-encoding 'gzip' $SITE_DIR $BUCKET \
|| { red '--> js upload failed' ; exit 4 ; }

# Sync media files (Cache: 4 hours)
yellow '--> Uploading images (jpg, png, ico)'
${AWS_S3_CMD} sync --exclude '*.*' --include '*.jpg' --content-type 'image/jpeg' --cache-control 'max-age=14400' $SITE_DIR $BUCKET \
|| { red '--> jpg upload failed' ; exit 4 ; }
${AWS_S3_CMD} sync --exclude '*.*' --include '*.png' --content-type 'image/png' --cache-control 'max-age=14400' $SITE_DIR $BUCKET \
|| { red '--> png upload failed' ; exit 4 ; }
${AWS_S3_CMD} sync --exclude '*.*' --include '*.ico' --content-type 'image/x-icon' --cache-control 'max-age=14400' $SITE_DIR $BUCKET \
|| { red '--> ico upload failed' ; exit 4 ; }

# Sync html files (Cache: 2 hours)
yellow '--> Uploading html files'
${AWS_S3_CMD} sync --exclude '*.*' --include '*.html' --content-type 'text/html' --cache-control 'max-age=7200, must-revalidate' --content-encoding 'gzip' $SITE_DIR $BUCKET \
|| { red '--> html upload failed' ; exit 4 ; }


# Sync everything else
yellow '--> Syncing everything else'
${AWS_S3_CMD} sync --delete $SITE_DIR $BUCKET \
|| { red '--> Sync failed' ; exit 4 ; }

green "Done deploying to $1 bucket"
