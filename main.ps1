# Establecer ruta de salida para el archivo LDIF
$outFile = "C:\usuarioss.ldif"

# Crear el archivo LDIF y agregar la estructura básica
"dn: ou=socios,dc=mibu,dc=local" | Out-File -FilePath $outFile -Encoding UTF8
"objectclass: organizationalUnit" | Out-File -FilePath $outFile -Encoding UTF8 -Append
"" | Out-File -FilePath $outFile -Encoding UTF8 -Append

# Obtener todos los usuarios de Active Directory
$users = Get-ADUser -Filter * -Properties samAccountName, unicodePwd

# Iterar sobre cada usuario y agregar al archivo LDIF
foreach ($user in $users) {
    $dn = "cn=" + $user.samAccountName + ",ou=socios,dc=,mibu,dc=local"
    $entry = "dn: " + $dn
    $entry += "`nobjectclass: inetOrgPerson"
    $entry += "`nsn: " + $user.surname
    $entry += "`ngivenName: " + $user.givenName
    $entry += "`nmail: " + $user.emailAddress
    $entry += "`nsamAccountName: " + $user.samAccountName
    $entry += "`nuserPassword:: " + [Convert]::ToBase64String($user.unicodePwd)
    $entry += "`n"
    
    $entry | Out-File -FilePath $outFile -Encoding UTF8 -Append
}

Write-Host "Exportación a LDIF completada."
