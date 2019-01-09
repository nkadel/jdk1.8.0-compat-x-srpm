# Copyright: Nico Kadel-Garcia <nkadel@gmail.com>

Summary: RPM plugin to allow Oracle Java to fulfill other Java requirement
Version: 1.8.0
Name: jdk%{version}-compat
Release: 0%{?dist}
License: Java
Group: Development/Tools
URL: URL_REF

Packager: Nico Kadel-Garcia <nkadel@gmail.com>

BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

Requires: java-%{version}
Requires: jre-%{version}
Provides: java-headless = 1:%{version}
Conflicts: java*openjdk*

%description
%{name} provides the dependency needed for Java dependent components
to operate with the upstream packaged Oracle JDK.

%prep
#%setup

#%build

#%install

#%clean
%{__rm} -rf %{buildroot}

%files

%changelog
* Tue Jan 8 2019 Nico Kadel-Garcia <nkadel@gmail.com> - 1.8.0-0
- Initial build

