���5p���d������� �g��j ����v8�-e"T�@����|����MY
E8��j2P�C��;묰��x��EVL�
/���v*Y �'��r4�h��D���4�h�M3�j��c��=a.W��F�7�id�����8�mEL�J:H��r)a4ר�AG��[�D�̄����7�)~a���Ic�15+���wߙg�`����|��	W�M?�o���b4�h�G��JH��x�A6O��8��C�N.K���]5h�~s����`��̑j���r<�n$Ӥ��|�w�K���Y}|��9W�B�_ۇ�t�X�S��.{���16k��3ߪ'��o����=FnM�r�ud�ԥ`��ܡf�=P�C�:��8�mW�ARO�K�H��EY�:,��26ji�3�6 �?�/����>/�c�)1!+���G��f*U ����s��=d�T������yt��uE��j8��c�V:A,Ϣ+�`��qn[����vY2E*L��7��qq������S� �g�������5y(�!fg�P����<��
���_���-p�[�D��:l��8�mFRMJ~H߉g�e0��ష��h�A3��������^>G��C�N$ˤ���\���1fk�����"<�n5��z���'�%w��D�����9;�,�bVw�_���i~Q���	g�M0�k�бc˖(�!S��^|Ş-W�AFO��x��D�L�
��=y.]#�f6p��4����Z��ܹf:p���$�d�Ԛ ��еc��)a!��EK�Ț)T� ���O��8��L�JH��yY6|�17��@�߻�̵j��c�>q/��Ԇ �'�eaװ�Kǈ�YBEL��<��s������H�I[��<�.��
98�-rbZVD�����*?�����z2\�F0�+�`����h��IS�>u/���v �'�%t�ش�H��\�=?�oÓ�3�j
P���n>S���~'��W��l���~"_�G�l�R<�n.S���g�p����4�h�Vs���ȹiM
s��d�T���/ۣ�4�(�aQ��^���MVJAϹk��s��/����8�-Y"E&L�
4��qN[�����V�3�3��/����<�.#�f�: ���5zh��f#�&�3��8��K�H�IL�
)8�-w�YFE�z<��&3�*����	��7�ip�㴶�9Y-b|�^5��A~O���ءeG��P�C��/���;�,�b|�;���Bu;��r�s��4�脱\���5Vh�o���(�azW��V/�#ߦ'�%l��4�h�Q]�~�w�i5(�z��V>A/����$�$�d�T���_Ӈ�vvY5<��1s�� ��п���+� �'�ek�А���"-&beT� ��̏�������ZD�����������@���k���Ⱥ)L�
7��Mq
[�čl�R�p�[Ä���	7�)M!
g��M`�W��qo��Ԓ �g�Ub@�O����MM
Jx��ifQ������O�K�Ȼ�L�
���}Z^Dǌ�ZD�L�����|����EM�z(��f7�)P���9O��x�]C�N�x�Y6E)�:7��B1k�����$�d�T���/���7�)i!'��J���~����k��3˪(��_���]}^}�}W�AW��[߄�܅f�6 �'�%{�܄��6�61)+� ���EfL�
 ���u~X߅g��f �'��w��x�D�L�
8�m|�^"G�ME
L��=h�Qs�����K��y@��{���y:],�b-bq[�����[�ċ옲Jp���d������X��G��r*Z`���r�}T�@���[�Ĳ,�b�ua׵aH׉aY�1\�0�+�`�ǱmK�H�IRII>I/�#�&%%$�䴴���YU ���?������?����>?�����.3�� �?�o����?�o�S�=>no���"rfZU������?ϯ���;ì��~���̡j��S�B?�oۓ�4�h�QRC�NK���YY<and unmounts it
# automatically. In later versions of OSX, the operating system handles this for
# the end user.
#
class Chef
  class Provider::XcodeCommandLineToolsFromDmg < Provider::LWRPBase
    action(:install) do
      if installed?
        Chef::Log.debug("#{new_resource} already installed - skipping")
      else
        converge_by("Install #{new_resource}") do
          download
          attach
          install
          detach
        end
      end
    end

    private

    #
    # Determine if the XCode Command Line Tools are installed
    #
    # @return [true, false]
    #
    def installed?
      cmd = Mixlib::ShellOut.new('pkgutil --pkgs=com.apple.pkg.DeveloperToolsCLI')
      cmd.run_command
      cmd.error!
      true
    rescue Mixlib::ShellOut::ShellCommandFailed
      false
    end

    #
    # The path where the dmg should be cached on disk.
    #
    # @return [String]
    #
    def dmg_cache_path
      ::File.join(Chef::Config[:file_cache_path], 'osx-command-line-tools.dmg')
    end

    #
    # The path where the dmg should be downloaded from. This is intentionally
    # not a configurable object by the end user. If you do not like where we
    # are downloading XCode from - too bad.
    #
    # @return [String]
    #
    def dmg_remote_source
      case node['platform_version'].to_f
      when 10.7
        'http://devimages.apple.com/downloads/xcode/command_line_tools_for_xcode_os_x_lion_april_2013.dmg'
      when 10.8
        'http://devimages.apple.com/downloads/xcode/command_line_tools_for_xcode_os_x_mountain_lion_march_2014.dmg'
      else
        raise "Unknown DMG download URL for OSX #{node['platform_version']}"
      end
    end

    #
    # The path where the volume should be mounted.
    #
    # @return [String]
    #
    def mount_path
      ::File.join(Chef::Config[:file_cache_path], 'osx-command-line-tools')
    end

    #
    # Action: download the remote dmg.
    #
    # @return [void]
    #
    def download
      remote_file = Resource::RemoteFile.new(dmg_cache_path, run_context)
      remote_file.source(dmg_remote_source)
      remote_file.backup(false)
      remote_file.run_action(:create)
    end

    #
    # Action: attach the dmg (basically, double-click on it)
    #
    # @return [void]
    #
    def attach
      execute %(hdiutil attach "#{dmg_cache_path}" -mountpoint "#{mount_path}")
    end

    #
    # Action: install the package inside the dmg
    #
    # @return [void]
    #
    def install
      execute %|installer -package "$(find '#{mount_path}' -name *.mpkg)" -target "/"|
    end

    #
    # Action: detach the dmg (basically, drag it to eject on the dock)
    #
    # @return [void]
    #
    def detach
      execute %(hdiutil detach "#{mount_path}")
    end
  end
end

class Chef
  class Provider::XcodeCommandLineToolsFromSoftwareUpdate < Provider::LWRPBase
    action(:install) do
      if installed?
        Chef::Log.debug("#{new_resource} already installed - skipping")
      else
        converge_by("Install #{new_resource}") do
          # This script was graciously borrowed and modified from Tim Sutton's
          # osx-vm-templates at https://github.com/timsutton/osx-vm-templates/blob/b001475df54a9808d3d56d06e71b8fa3001fff42/scripts/xcode-cli-tools.sh
          execute 'install XCode Command Line tools' do
            command <<-EOH.gsub(/^ {14}/, '')
              # create the placeholder file that's checked by CLI updates' .dist code
              # in Apple's SUS catalog
              touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
              # find the CLI Tools update
              PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
              # install it
              softwareupdate -i "$PROD" -v
            EOH
            # rubocop:enable Metrics/LineLength
          end
        end
      end
    end

    private

    #
    # Determine if the XCode Command Line Tools are installed
    #
    # @return [true, false]
    #
    def installed?
      cmd = Mixlib::ShellOut.new('pkgutil --pkgs=com.apple.pkg.CLTools_Executables')
      cmd.run_command
      cmd.error!
      true
    rescue Mixlib::ShellOut::ShellCommandFailed
      false
    end
  end
end
