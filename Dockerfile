ARG IMAGE=store/intersystems/iris-community:2020.1.0.204.0
ARG IMAGE=intersystemsdc/iris-community:2020.1.0.209.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.2.0.196.0-zpm
ARG IMAGE=store/intersystems/iris-aa-community:2020.3.0AA.331.0
FROM $IMAGE
ENV NameSpace=IRISAPP \
    app=irisapp
USER root

WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
COPY irissession.sh /
RUN chmod +x /irissession.sh 

USER ${ISC_PACKAGE_MGRUSER}

COPY  Installer.cls .
COPY  src src
SHELL ["/irissession.sh"]

RUN \
  do $SYSTEM.OBJ.Load("Installer.cls", "ck") \
  set sc = ##class(App.Installer).setup() \
  zn "%SYS" \
  set webName = "/csp/${app}" \
  write "Modify "_webName_" web application ...",! \
  set webProperties("NameSpace") = ${NameSpace} \
  set webProperties("Enabled") = 1 \
  set webProperties("CSPZENEnabled") = 1 \
  set webProperties("AutheEnabled") = 32 \
  set webProperties("iKnowEnabled") = 1 \
  set webProperties("DeepSeeEnabled") = 1 \
  set sc = ##class(Security.Applications).Modify(webName, .webProperties) \
  write "Web application "_webName_" has been updated!",!\
  set webName = "/crud" \
  write "Create "_webName_" web application ..." \
  set webProperties("DispatchClass") = "Sample.PersonREST" \
  set webProperties("NameSpace") = ${NameSpace} \
  set webProperties("Enabled") = 1 \
  set webProperties("AutheEnabled") = 32 \
  set sc = ##class(Security.Applications).Create(webName, .webProperties) \
  write sc \
  write "Web application "_webName_" has been created!"



# bringing the standard shell back
SHELL ["/bin/bash", "-c"]
