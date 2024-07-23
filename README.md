# Unofficial Modding Guide

## Commiting/Adding Information
We encourage you to add information, whether it be new pages or editing existing guides. However, you must abide by the correct formatting. Review this guide to understand how: https://chirpy.cotes.page/posts/write-a-new-post/

### Breakdown of Creating a New Post
*copied from: https://chirpy.cotes.page/posts/write-a-new-post/*
1. Create a new file named YYYY-MM-DD-TITLE.EXTENSION and put it in the _posts of the root directory.
2. Add the following information to the top:
  ```
  ---
  title: TITLE
  date: 2022-07-20 00:00:00 +0000 # YYYY=DD-MM HH:MM:SS +OFFSET
  categories: [CATEGORY, SUBCATEGORY]
  tags: [TAG_1, TAG_2]
  description: DESCRIPTION
  author: "AUTHOR_1|NEXUS_LINK_1,AUTHOR_2|NEXUS_LINK_2"
  ---
  ```
3. Write your guide using markdown formatting.

## Running a local website on Windows
1. Download and install `Ruby+Devkit 3.1.6-1 (x64)`
2. In a new command prompt, run `gem install jekyll bundler`
3. `cd` to this git directory
4. Run `bundle install`
5. If you have an error installing `wdm` run the below then `bundle install` again:  
`gem install wdm -- --with-cflags=-Wno-implicit-function-declaration`
6. To start the server run `bundle exec jekyll s`
