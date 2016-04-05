



# Rsync

```
# bar.csvだけ
rsync -avz --include "*/" --include "bar.csv" --exclude "*" foo/ host:foo/
```

http://tech.nitoyon.com/ja/blog/2013/03/26/rsync-include-exclude/


# Move svn to git
$ git svn clone svn+ssh://sakura09.lumber-mill.co.jp/repos/kanesue.svn/eclipse/trunk/kanesue_eos --authors-file=crashed/users_for_git.txt --no-metadata

$ svn rm svn+ssh://sakura09.lumber-mill.co.jp/repos/kanesue.svn/eclipse/trunk/kanesue_eos

svn log -r {2015-10-11}:HEAD svn+ssh://sakura09/repos/kanesue.svn

# Wordpress plugins
Google Analytics by Yoast 5.3.3
Materials

# Image materials
http://www.sitebuilderreport.com/stock-up
http://www.pexels.com/
