#contains information on all the words used in our preliminary study
#### NOT USED ANYMORE
module AllWords
    WordURLs = %w(
http://wordnetweb.princeton.edu/perl/webwn?s=aberration+&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00
http://wordnetweb.princeton.edu/perl/webwn?s=apprehensive&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000
http://wordnetweb.princeton.edu/perl/webwn?s=ardent+&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00
http://wordnetweb.princeton.edu/perl/webwn?s=assuage&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=benign&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0000
http://wordnetweb.princeton.edu/perl/webwn?s=beset&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000
http://wordnetweb.princeton.edu/perl/webwn?s=besiege&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000
http://wordnetweb.princeton.edu/perl/webwn?s=candid&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=deference&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=dissociate&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000000
http://wordnetweb.princeton.edu/perl/webwn?s=efface&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00
http://wordnetweb.princeton.edu/perl/webwn?s=effervescent&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000
http://wordnetweb.princeton.edu/perl/webwn?s=espouse&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=fallacious&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=hefty&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00
http://wordnetweb.princeton.edu/perl/webwn?s=humane&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=illuminate&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=imbue&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000
http://wordnetweb.princeton.edu/perl/webwn?s=inert&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000
http://wordnetweb.princeton.edu/perl/webwn?s=insidious&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=insular&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00
http://wordnetweb.princeton.edu/perl/webwn?s=merge&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0000
http://wordnetweb.princeton.edu/perl/webwn?s=mundane&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=neophyte&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=nullify&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=ponderous&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=pretentious&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=prodigious&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00
http://wordnetweb.princeton.edu/perl/webwn?s=propensity&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=
http://wordnetweb.princeton.edu/perl/webwn?s=redolent&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=reticent&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00
http://wordnetweb.princeton.edu/perl/webwn?s=sterile&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=stultify&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=superficial+&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00
http://wordnetweb.princeton.edu/perl/webwn?s=tenacious&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0
http://wordnetweb.princeton.edu/perl/webwn?s=virulent&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000
http://wordnetweb.princeton.edu/perl/webwn?s=investigator&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000
http://wordnetweb.princeton.edu/perl/webwn?s=globe&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00
http://wordnetweb.princeton.edu/perl/webwn?s=assemble&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000
http://wordnetweb.princeton.edu/perl/webwn?s=politician&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00000
http://wordnetweb.princeton.edu/perl/webwn?s=vessel&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000
http://wordnetweb.princeton.edu/perl/webwn?s=manner&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0000
http://wordnetweb.princeton.edu/perl/webwn?s=attract&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000000
http://wordnetweb.princeton.edu/perl/webwn?s=impose&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=000000
http://wordnetweb.princeton.edu/perl/webwn?s=scenario&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0000000
http://wordnetweb.princeton.edu/perl/webwn?s=beauty&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00
http://wordnetweb.princeton.edu/perl/webwn?s=criticism&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0000000000
http://wordnetweb.princeton.edu/perl/webwn?s=producer&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=00
http://wordnetweb.princeton.edu/perl/webwn?s=synthesis&sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=0000000
http://wordnetweb.princeton.edu/perl/webwn?s=deport&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&
    )

  #parse out the words and create a convenient hash
  WordToURL = WordURLs.inject({}){|hash, url| hash[url.match(/http:\/\/wordnetweb.princeton.edu\/perl\/webwn\?s=(\w+)/)[1]] = url; hash}

  AllWordsVer = "March 21, 2011"
end
