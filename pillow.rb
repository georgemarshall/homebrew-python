require 'formula'

class Pillow < Formula
  homepage 'https://github.com/python-imaging/Pillow'
  url 'https://github.com/python-imaging/Pillow/archive/2.4.0.tar.gz'
  sha1 '2e07dd7545177019331e8f3916335b69869e82b0'
  head 'https://github.com/python-imaging/Pillow.git'

  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on 'freetype'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'little-cms2'
  depends_on 'openjpeg'
  depends_on 'webp'

  def install
    # Help pillow find zlib and freetype2
    inreplace "setup.py" do |s|
      s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{MacOS.sdk_path}/usr/lib', '#{MacOS.sdk_path}/usr/include')" unless MacOS::CLT.installed?
      s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
    end

    Language::Python.each_python(build) do |python, version|
      system python, "setup.py", "install", "--prefix=#{prefix}", "--record=installed.txt", "--single-version-externally-managed"
    end
  end

  test do
    Language::Python.each_python(build) do |python, version|
      # Only a small test until https://github.com/python-imaging/Pillow/issues/17
      system python, "-c", "import PIL.Image"
    end
  end
end
