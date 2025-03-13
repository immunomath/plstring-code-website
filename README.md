# plstring-code-jekyll

Source code for the GL String Code web site, built using the popular
Jekyll static site generator.

See also:  https://jekyllrb.com/docs/

Much of the site's static content is written in kramdown, a variant of
Markdown.

See also:  https://kramdown.gettalong.org/

## Setup

If needed (e.g. under MacOS, using Homebrew) install Ruby.

```
$ brew install ruby
...
$ export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
$ which ruby
$ ruby -v
```

Install Jekyll and Bundler gems (e.g. under MacOS).

```
$ gem --help
...
$ gem help install
...
$ gem install --bindir /opt/homebrew/opt/ruby/bin bundler jekyll
```

## Build and view site

Build the site and start a local server to host it.

```
$ cd jekyll-site
$ bundle exec jekyll serve
```

Browse http://localhost:4000/ to view the locally hosted site.

Note:  To select a different Jekyll version, before doing the above
edit the jekyll version in Gemfile and run `bundle install`, e.g.

```
$ rm Gemfile.lock 
$ vi Gemfile
$ bundle install
```

## Deploy to Amazon S3

The `Jekyll-S3.sh` script can be used to deploy the site to an Amazon S3
bucket.  To use it, first install `okta-awscli` and the AWS command line
interface (AWS CLI, a.k.a. `awscli`).  E.g. (MacOS):

```
$ brew install okta-awscli
...
$ brew install awscli
...
```

The `okta-awscli` tool uses the AWS Security Token Service (AWS STS) to
create and provide trusted users with temporary security credentials.
Documentation on how to configure `okta-awscli` for use with the NMDP's
BIO and GDR AWS segments is available on Confluence, here:

[AWS CLI access with Okta (with MFA) - BIO and GDR](https://confluence.nmdp.org/display/BIO/AWS+CLI+access+with+Okta+%28with+MFA%29+-+BIO+and+GDR)

To acquire a temporary security credential using `okta-awscli`, enter
a command such as the following.

```
$ okta-awscli --okta-profile bio --profile bio
Enter password:
```

The temporary security credential enables use of both the AWS CLI and the
`Jekyll-S3.sh` script.  AWS CLI usage example:

```
$ aws --profile bio s3 ls s3://plstring-org-staging
...
```

### Deploy to staging bucket

```
$ cd jekyll-site
$ ../Jekyll-S3.sh staging
...
```

To view the staging site, browse
http://plstring-org-staging.s3-website-us-east-1.amazonaws.com/.

### Deploy to live (www) bucket

```
$ cd jekyll-site
$ ../Jekyll-S3.sh live
...
```

To view the live site, browse https://plstring.org/
or http://plstring.org.s3-website-us-east-1.amazonaws.com/.

The HTTPS site may not update immediately, because it is cached by CloudFront.
To force the CloudFront cache to update immediately (i.e. invalidate the cache),
see the following.

https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html

