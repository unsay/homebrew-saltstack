require 'formula'

class Saltstack < Formula
  homepage 'http://saltstack.org/'
  url 'https://github.com/downloads/saltstack/salt/salt-0.10.3.tar.gz'
  sha1 '01d95378dc00c6586ea2c25ccf79a2b3a9cf45c6'

  depends_on 'zeromq'
  depends_on 'swig' => :build

  def patches
    { # Fix bugs in homebrew salt module
      :p1 => "https://github.com/saltstack/salt/commit/ae7365c6a66da89d71e73cc2c41b6814b616e7c0.diff",
      # Change paths to match Homebrew standards
      :p0 => DATA
    }
  end

  def install
    # Add folders to path (Superenv removes these)
    # TODO: Move away from system virtualenv and use homebrew python
    ENV.append "PATH", "/usr/local/bin", ":"
    ENV.append "PATH", ( HOMEBREW_PREFIX / 'bin'), ":"
    system "virtualenv", "#{prefix}/salt.venv"
    system "#{prefix}/salt.venv/bin/pip", "install", "-r", "requirements.txt"
    system "#{prefix}/salt.venv/bin/python", "setup.py", "install",
                     "--prefix=#{prefix}/salt.venv"
    bin.install_symlink "#{prefix}/salt.venv/bin/salt"
    bin.install_symlink "#{prefix}/salt.venv/bin/salt-call"
    bin.install_symlink "#{prefix}/salt.venv/bin/salt-cp"
    bin.install_symlink "#{prefix}/salt.venv/bin/salt-key"
    bin.install_symlink "#{prefix}/salt.venv/bin/salt-master"
    bin.install_symlink "#{prefix}/salt.venv/bin/salt-minion"
    bin.install_symlink "#{prefix}/salt.venv/bin/salt-run"
    bin.install_symlink "#{prefix}/salt.venv/bin/salt-syndic"
  end

  def test
    system "salt --version"
  end
end
__END__

# Change paths to match Homebrew standards. Generated with the following script:
#
# PATCHFILES="salt/config.py salt/utils/parsers.py salt/cli/key.py salt/client.py"
# sed -i .orig \
#   -e 's@/etc/@HOMEBREW_PREFIX/etc/@g' \
#   -e 's@/var/@HOMEBREW_PREFIX/var/@g' \
#   -e 's@/srv/@HOMEBREW_PREFIX/srv/@g' \
#   $PATCHFILES
# for f in $PATCHFILES; do diff -u $f.orig $f; done
#

--- salt/config.py.orig	2012-09-26 19:13:37.000000000 -0700
+++ salt/config.py	2012-10-16 14:46:46.000000000 -0700
@@ -38,7 +38,7 @@
     if not isinstance(file_roots, dict):
         log.warning('The file_roots parameter is not properly formatted,'
                     ' using defaults')
-        return {'base': ['/srv/salt']}
+        return {'base': ['HOMEBREW_PREFIX/srv/salt']}
     for env, dirs in list(file_roots.items()):
         if not isinstance(dirs, list) and not isinstance(dirs, tuple):
             file_roots[env] = []
@@ -153,12 +153,12 @@
             'master_finger': '',
             'user': 'root',
             'root_dir': '/',
-            'pki_dir': '/etc/salt/pki',
+            'pki_dir': 'HOMEBREW_PREFIX/etc/salt/pki',
             'id': socket.getfqdn(),
-            'cachedir': '/var/cache/salt',
+            'cachedir': 'HOMEBREW_PREFIX/var/cache/salt',
             'cache_jobs': False,
             'conf_file': path,
-            'sock_dir': '/var/run/salt',
+            'sock_dir': 'HOMEBREW_PREFIX/var/run/salt',
             'backup_mode': '',
             'renderer': 'yaml_jinja',
             'failhard': False,
@@ -170,10 +170,10 @@
             'top_file': '',
             'file_client': 'remote',
             'file_roots': {
-                'base': ['/srv/salt'],
+                'base': ['HOMEBREW_PREFIX/srv/salt'],
                 },
             'pillar_roots': {
-                'base': ['/srv/pillar'],
+                'base': ['HOMEBREW_PREFIX/srv/pillar'],
                 },
             'hash_type': 'md5',
             'external_nodes': '',
@@ -191,7 +191,7 @@
             'ipc_mode': 'ipc',
             'tcp_pub_port': 4510,
             'tcp_pull_port': 4511,
-            'log_file': '/var/log/salt/minion',
+            'log_file': 'HOMEBREW_PREFIX/var/log/salt/minion',
             'log_level': None,
             'log_level_logfile': None,
             'log_datefmt': __dflt_log_datefmt,
@@ -258,21 +258,21 @@
             'publish_port': '4505',
             'user': 'root',
             'worker_threads': 5,
-            'sock_dir': '/var/run/salt',
+            'sock_dir': 'HOMEBREW_PREFIX/var/run/salt',
             'ret_port': '4506',
             'timeout': 5,
             'keep_jobs': 24,
             'root_dir': '/',
-            'pki_dir': '/etc/salt/pki',
-            'cachedir': '/var/cache/salt',
+            'pki_dir': 'HOMEBREW_PREFIX/etc/salt/pki',
+            'cachedir': 'HOMEBREW_PREFIX/var/cache/salt',
             'file_roots': {
-                'base': ['/srv/salt'],
+                'base': ['HOMEBREW_PREFIX/srv/salt'],
                 },
             'master_roots': {
-                'base': ['/srv/salt-master'],
+                'base': ['HOMEBREW_PREFIX/srv/salt-master'],
                 },
             'pillar_roots': {
-                'base': ['/srv/pillar'],
+                'base': ['HOMEBREW_PREFIX/srv/pillar'],
                 },
             'ext_pillar': {},
             'syndic_master': '',
@@ -292,14 +292,14 @@
             'order_masters': False,
             'job_cache': True,
             'minion_data_cache': True,
-            'log_file': '/var/log/salt/master',
+            'log_file': 'HOMEBREW_PREFIX/var/log/salt/master',
             'log_level': None,
             'log_level_logfile': None,
             'log_datefmt': __dflt_log_datefmt,
             'log_fmt_console': __dflt_log_fmt_console,
             'log_fmt_logfile': __dflt_log_fmt_logfile,
             'log_granular_levels': {},
-            'pidfile': '/var/run/salt-master.pid',
+            'pidfile': 'HOMEBREW_PREFIX/var/run/salt-master.pid',
             'cluster_masters': [],
             'cluster_mode': 'paranoid',
             'range_server': 'range:80',
@@ -308,7 +308,7 @@
             'state_output': 'full',
             'nodegroups': {},
             'cython_enable': False,
-            'key_logfile': '/var/log/salt/key',
+            'key_logfile': 'HOMEBREW_PREFIX/var/log/salt/key',
             'verify_env': True,
             'permissive_pki_access': False,
             'default_include': 'master.d/*.conf',
--- salt/utils/parsers.py.orig	2012-09-22 08:43:25.000000000 -0700
+++ salt/utils/parsers.py	2012-10-16 14:46:46.000000000 -0700
@@ -165,7 +165,7 @@
 
     def _mixin_setup(self):
         self.add_option(
-            '-c', '--config-dir', default='/etc/salt',
+            '-c', '--config-dir', default='HOMEBREW_PREFIX/etc/salt',
             help=('Pass in an alternative configuration directory. Default: '
                   '%default')
         )
@@ -359,7 +359,7 @@
     def _mixin_setup(self):
         self.add_option(
             '--pid-file', dest='pidfile',
-            default='/var/run/{0}.pid'.format(self.get_prog_name()),
+            default='HOMEBREW_PREFIX/var/run/{0}.pid'.format(self.get_prog_name()),
             help=('Specify the location of the pidfile. Default: %default')
         )
 
@@ -867,7 +867,7 @@
 
         self.add_option(
             '--key-logfile',
-            default='/var/log/salt/key',
+            default='HOMEBREW_PREFIX/var/log/salt/key',
             help=('Send all output to a file. Default is %default')
         )
 
--- salt/cli/key.py.orig	2012-09-26 09:09:11.000000000 -0700
+++ salt/cli/key.py	2012-10-16 14:46:46.000000000 -0700
@@ -65,7 +65,7 @@
                 'gen_keys': '',
                 'gen_keys_dir': '.',
                 'keysize': 2048,
-                'conf_file': '/etc/salt/master',
+                'conf_file': 'HOMEBREW_PREFIX/etc/salt/master',
                 'raw_out': False,
                 'yaml_out': False,
                 'json_out': False,
--- salt/client.py.orig	2012-09-16 21:36:10.000000000 -0700
+++ salt/client.py	2012-10-16 14:46:46.000000000 -0700
@@ -69,7 +69,7 @@
     '''
     Connect to the salt master via the local server and via root
     '''
-    def __init__(self, c_path='/etc/salt/master'):
+    def __init__(self, c_path='HOMEBREW_PREFIX/etc/salt/master'):
         self.opts = salt.config.master_config(c_path)
         self.serial = salt.payload.Serial(self.opts)
         self.salt_user = self.__get_user()
@@ -1107,7 +1107,7 @@
     '''
     Create an object used to call salt functions directly on a minion
     '''
-    def __init__(self, c_path='/etc/salt/minion'):
+    def __init__(self, c_path='HOMEBREW_PREFIX/etc/salt/minion'):
         self.opts = salt.config.minion_config(c_path)
         self.sminion = salt.minion.SMinion(self.opts)
 
