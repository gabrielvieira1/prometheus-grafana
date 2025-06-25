Write-Host "Iniciando aplicação em perfil 'prod'..."
& java "-Xms128M" "-Xmx128M" "-Dspring.profiles.active=prod" "-jar" "target/forum.jar"
