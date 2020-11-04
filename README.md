# bash_sql_report_cvs
Envio de reportes CVS desde bash con mysql, mutt y certificados SLL
* Coloca tus certificados en el mismo lugar que este BASH si los quieres crear apenas checa el repo que te dejo aqui abajo para ver como crearlos:
* https://github.com/areliszxz/grpcs-grpc-nginx-grpcs_go-grpcs_node-grpcs_java 

# Requisitos
* Instala mutt y configurar para el envio de correo
  * apt install mutt
  * Busca el archivo .muttrc normalmente esta en /root/ y abrelo para editar y agregale la info de del archivo .muttrc del repo
* Linux (debian de preferencia o compatible) con acceso a teminal 
* Tener mysql server y crear el ususario para reportear (con tener solo permiso de select y bloqueo de tablas)
 * Crea tu tabla con los campos id(Auto numerico,key),campo1,campo2,campo3,fecha(*tipo fecha importante)
