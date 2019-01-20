# Copyright: Nico Kadel-Garcia <nkadel@gmail.com>

Summary: RPM plugin to allow Oracle Java to fulfill other Java requirement
Version: 1.8.0
Name: jdk%{version}-compat
Release: 0.1%{?dist}
License: Java
Group: Development/Tools
URL: URL_REF

Packager: Nico Kadel-Garcia <nkadel@gmail.com>

BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
Requires: java-%{version}
Requires: jre-%{version}
Provides: java-headless = 1:%{version}
Provides: java-devel = 1:%{version}
Conflicts: java*openjdk*

%description
%{name} provides the dependency needed for Java dependent components
to operate with the upstream packaged Oracle JDK.

%prep
#%setup -c

%build
true

%install
true

%clean
%{__rm} -rf %{buildroot}

%files

%changelog
* Sun Jan 20 2019 Nico Kadel-Garcia <nkadel@gmail.com> - 1.8.0-0.1
- Add Provides for java-devel 1:version, to support ant and other Java programs
  that do not use jre-headless
- Add "true" hooks to build and install

* Tue Jan 8 2019 Nico Kadel-Garcia <nkadel@gmail.com> - 1.8.0-0
- Initial build

