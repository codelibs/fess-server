%define __jar_repack 0

%global dbtype __DBTYPE__
%global fess_version __FESS_VERSION__
%global fess_pkg_version __FESS_PKG_VERSION__
%global fess_release __FESS_REVISION__
%global product_root __PRODUCT_ROOT__
%global product_name __PRODUCT_NAME__
%global user_name __USER_NAME__

%if %{dbtype}
Name:    %{product_name}-server-%{dbtype}
%else
Name:    %{product_name}-server-h2
%endif
Version: %{fess_version}
Release: %{fess_release}
Epoch:   1
Summary: Fess Server
Group:   Applications/Multimedia
BuildArch: noarch
License:  Apache License, Version 2.0
URL:      http://fess.sourceforge.jp/
BuildRoot: %{_tmpdir}/%{name}-%{version}-%{release}

%if %{dbtype}
Source0:  fess-server-%{dbtype}-%{fess_pkg_version}.zip
%else
Source0:  fess-server-%{fess_pkg_version}.zip
%endif

BuildRequires: unzip

Requires:      jdk >= 1.6.0
Requires(pre): user(%{user_name})
Requires(pre): group(%{user_name})
Requires(pre): shadow-utils
Provides:      user(%{user_name})
Provides:      group(%{user_name})

Requires(post): chkconfig
Requires(preun): chkconfig
Requires(preun): initscripts
Requires(postun): initscripts

%if "%{dbtype}" == "mysql"
Requires:      mysql-server
%endif

%description
Fess is Java based full text search server provided as OSS product. 

%prep
rm -rf "${RPM_BUILD_ROOT}"
%setup -q -n fess-server-%{fess_pkg_version}

%build

%install
mkdir -p $RPM_BUILD_ROOT%{product_root}
cp -r $RPM_BUILD_DIR/fess-server-%{fess_pkg_version} $RPM_BUILD_ROOT%{product_root}/%{product_name}
%if "%{product_name}" != "fess"
    mv $RPM_BUILD_ROOT%{product_root}/%{product_name}/webapps/fess $RPM_BUILD_ROOT%{product_root}/%{product_name}/webapps/%{product_name}
%endif
rm -f $RPM_BUILD_ROOT%{product_root}/%{product_name}/webapps/*.war

TMP_FILE=/tmp/build.$$

sed -e "s/\(echo \"Using.*\)/\1 > \/dev\/null/" \
    $RPM_BUILD_ROOT%{product_root}/%{product_name}/bin/catalina.sh > $TMP_FILE
cp $TMP_FILE $RPM_BUILD_ROOT%{product_root}/%{product_name}/bin/catalina.sh 

sed -e "s/\/fess\//\/%{product_name}\//g" \
    $RPM_BUILD_ROOT%{product_root}/%{product_name}/webapps/%{product_name}/WEB-INF/web.xml > $TMP_FILE
cp $TMP_FILE $RPM_BUILD_ROOT%{product_root}/%{product_name}/webapps/%{product_name}/WEB-INF/web.xml

sed -e "s/\/fess\//\/%{product_name}\//g" \
    $RPM_BUILD_ROOT%{product_root}/%{product_name}/bin/setenv.sh > $TMP_FILE
cp $TMP_FILE $RPM_BUILD_ROOT%{product_root}/%{product_name}/bin/setenv.sh

sed -e "s/PRODUCT_NAME=.*/PRODUCT_NAME=%{product_name}/g" \
    $RPM_BUILD_ROOT%{product_root}/%{product_name}/extension/mysql/install.sh  > $TMP_FILE
cp $TMP_FILE $RPM_BUILD_ROOT%{product_root}/%{product_name}/extension/mysql/install.sh 

rm $TMP_FILE

mkdir -p $RPM_BUILD_ROOT%{product_root}/%{product_name}/webapps/%{product_name}/WEB-INF/conf
touch $RPM_BUILD_ROOT%{product_root}/%{product_name}/webapps/%{product_name}/WEB-INF/conf/solrserver.properties
touch $RPM_BUILD_ROOT%{product_root}/%{product_name}/webapps/%{product_name}/WEB-INF/conf/crawler.properties

chmod +x $RPM_BUILD_ROOT%{product_root}/%{product_name}/bin/*.sh
chmod +x $RPM_BUILD_ROOT%{product_root}/%{product_name}/extension/mysql/*.sh

mkdir -p $RPM_BUILD_ROOT/etc/init.d
sed -e "s/FESS_PROG=fess/FESS_PROG=%{product_name}/" \
    -e "s/FESS_USER=\"fess\"/FESS_USER=\"%{user_name}\"/" \
    $RPM_BUILD_DIR/fess-server-%{fess_pkg_version}/extension/scripts/fess > $RPM_BUILD_ROOT/etc/init.d/%{product_name}

%clean
rm -rf "${RPM_BUILD_ROOT}"

%pre
getent group %{user_name} >/dev/null || groupadd -r %{user_name}
getent passwd %{user_name} >/dev/null || \
useradd -d %{product_root}/%{product_name} -g %{user_name} -M -r %{user_name}
exit 0

%post
/sbin/chkconfig --add %{product_name}

%if "%{dbtype}" == "mysql"
    echo "Please run the following script to configure database."
    echo " %{product_root}/%{product_name}/extension/mysql/install.sh"
%endif

%preun
# only delete user on removal, not upgrade
if [ $1 = 0 ]; then
    /sbin/service %{product_name} stop > /dev/null 2>&1
    /sbin/chkconfig --del %{product_name}
    pkill -U %{user_name}
    userdel %{user_name}
    rm -rf %{product_root}/%{product_name}/logs/*
    rm -rf %{product_root}/%{product_name}/conf/Catalina
    rm -rf %{product_root}/%{product_name}/webapps/%{product_name}/WEB-INF/logs/*
else
    /sbin/service %{product_name} stop > /dev/null 2>&1
fi
rm -rf %{product_root}/%{product_name}/webapps/%{product_name}/jar
rm -rf %{product_root}/%{product_name}/work/*

%postun
if [ $1 -ge 1 ]; then
    /sbin/service %{product_name} start > /dev/null 2>&1
fi

%files 
%defattr(-,%{user_name},%{user_name},0755)
%{product_root}/%{product_name}

%attr(755,root,root) /etc/init.d/%{product_name}

%changelog


