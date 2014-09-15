
def step(description)
  description = "-- #{description} "
  description = description.ljust(80, '-')
  puts
  puts "\e[32m#{description}\e[0m"
end

def app_path(name)
  path = "/Applications/#{name}.app"
  ["~#{path}", path].each do |full_path|
    return full_path if File.directory?(full_path)
  end

  return nil
end

def app?(name)
  return !app_path(name).nil?
end

def link_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)
  if File.exists?(symlink_path)
    # Symlink already configured properly. Leave it alone.
    return if File.symlink?(symlink_path) and File.readlink(symlink_path) == original_path
    # Never move user's files without creating backups first
    number = 1
    loop do
      backup_path = "#{symlink_path}.bak"
      if number > 1
        backup_path = "#{backup_path}#{number}"
      end
      if File.exists?(backup_path)
        number += 1
        next
      end
      mv symlink_path, backup_path, :verbose => true
      break
    end
  end
  ln_s original_path, symlink_path, :verbose => true
end

def install_github_bundle(user, package)
  unless File.exist? File.expand_path("~/.vim/bundle/#{package}")
    sh "git clone https://github.com/#{user}/#{package} ~/.vim/bundle/#{package}"
  end
end

namespace :install do
  desc 'Install Vundle'
  task :vundle do
    step 'install vundle'
    install_github_bundle 'gmarik','vundle'
    sh 'vim -c "BundleInstall" -c "q" -c "q"'
  end
end

desc 'Install these config files.'
task :default do
  #step 'git submodules'
  #sh 'git submodule update --init'

  step 'setup symlink'
  link_file 'tmux.conf'         , '~/.tmux.conf'
  link_file 'vim'               , '~/.vim'
  link_file 'vimrc'             , '~/.vimrc'
  link_file 'vimrc.bundles'     , '~/.vimrc.bundles'
  link_file 'bashrc.local'      , '~/.bashrc.local'

  sh 'echo "if [ -f ~/.bashrc.local ]; then" >> ~/.bashrc'
  sh 'echo "    . ~/.bashrc.local" >> ~/.bashrc'
  sh 'echo "fi" >> ~/.bashrc'

  unless File.exist?(File.expand_path('~/.vimrc.local'))
    cp File.expand_path('vimrc.local'), File.expand_path('~/.vimrc.local'), :verbose => true
  end
  unless File.exist?(File.expand_path('~/.vimrc.bundles.local'))
    cp File.expand_path('vimrc.bundles.local'), File.expand_path('~/.vimrc.bundles.local'), :verbose => true
  end

  # Install Vundle and bundles
  Rake::Task['install:vundle'].invoke
end
