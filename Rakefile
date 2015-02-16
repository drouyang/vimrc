
def step(description)
  description = "-- #{description} "
  description = description.ljust(80, '-')
  puts
  puts "\e[32m#{description}\e[0m"
end

def link_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)
  backup_path = "#{symlink_path}.bak"
  if File.exists?(symlink_path) || File.symlink?(symlink_path)
    if File.symlink?(symlink_path)
      symlink_points_to_path = File.readlink(symlink_path)
      return if symlink_points_to_path == original_path
      # Symlinks can't just be moved like regular files. Recreate old one, and
      # remove it.
      if File.exists?(backup_path) || File.symlink?(backup_path)
        rm backup_path
      end
      ln_s symlink_points_to_path, backup_path, :verbose => true
      rm symlink_path
    else
      # Never move user's files without creating backups first
      mv symlink_path, backup_path, :verbose => true
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
  link_file 'vimrc.local'       , '~/.vimrc.local'
  link_file 'vimrc.bundles'     , '~/.vimrc.bundles'
  link_file 'bashrc.local'     , '~/.bashrc.local'

  unless File.exist?(File.expand_path('~/.vimrc.local'))
    cp File.expand_path('vimrc.local'), File.expand_path('~/.vimrc.local'), :verbose => true
  end
  unless File.exist?(File.expand_path('~/.vimrc.bundles.local'))
    cp File.expand_path('vimrc.bundles.local'), File.expand_path('~/.vimrc.bundles.local'), :verbose => true
  end

  # Install Vundle and bundles
  Rake::Task['install:vundle'].invoke
end
