export EDITOR='vim'
export JWT_SIGNING_KEY=localKeyTellEverybody
export LOCAL_TOKEN=true

export JAVA_HOME=$(/usr/libexec/java_home)
export M2_HOME=/usr/local/Cellar/maven/3.5.2/
export GRADLE_HOME=~/Applications/ActiveVersions/Gradle
export PHANTOM_JS=~/Applications/ActiveVersions/PhantomJS

export PATH="$M2_HOME/bin:$GRADLE_HOME/bin:$PHANTOM_JS/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$DOTFILES/bin" #:/usr/local/Cellar/elixir/1.5.1/bin"
export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
export GROOVY_HOME=/usr/local/opt/groovy/libexec
