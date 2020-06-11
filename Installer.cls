Class App.Installer
{

XData setup
{
<Manifest>
  <Default Name="SourceDir" Value="#{$system.Process.CurrentDirectory()}src"/>

  <Namespace Name="${NameSpace}" Code="${NameSpace}" Data="${NameSpace}" Create="yes" Ensemble="1">

    <Configuration>
      <Database Name="${NameSpace}" Dir="/opt/${app}/data" Create="yes" Resource="%DB_${NameSpace}"/>
    </Configuration>
    <Import File="${SourceDir}" Flags="ck" Recurse="1"/>
    <CSPApplication Url="/csp/${app}" Directory="${cspdir}${app}"  ServeFiles="1" Recurse="1" MatchRoles=":%DB_${NameSpace}" AuthenticationMethods="32"
    />
  </Namespace>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

}
