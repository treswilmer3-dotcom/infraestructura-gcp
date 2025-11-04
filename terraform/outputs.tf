# Mostrar información de la instancia
output "instance_name" {
  description = "Nombre de la instancia de Compute Engine"
  value       = module.vm.instance_name
}

output "instance_ip" {
  description = "IP pública de la instancia"
  value       = module.vm.instance_ip
}

# Resumen detallado del despliegue
output "resumen_despliegue" {
  description = "Resumen detallado de la infraestructura desplegada"
  value = <<EOT

  ✅ INFRAESTRUCTURA DESPLEGADA EXITOSAMENTE

  🌐 RED Y CONECTIVIDAD
  - VPC: ${var.vpc_name}
  - Subred: ${var.subnet_name} (${var.subnet_cidr})
  - Región: ${var.region}
  - Zona: ${var.zone}

  🖥️  INSTANCIA DE COMPUTO
  - Nombre: ${module.vm.instance_name}
  - IP Pública: ${module.vm.instance_ip}
  - Tipo de máquina: e2-micro
  - SO: Debian 11
  - Puerto SSH: ${var.ssh_port}

  🔒 CONFIGURACIÓN DE SEGURIDAD
  - Usuario SSH: ${var.ssh_user}
  - Acceso SSH permitido desde: ${var.allowed_ssh_cidr}

  🔗 INSTRUCCIONES DE CONEXIÓN:
  Para conectarte por SSH, usa el siguiente comando:
  ssh -i ~/.ssh/tu_clave_privada ${var.ssh_user}@${module.vm.instance_ip} -p ${var.ssh_port}

  💡 RECUERDA:
  - Asegúrate de tener configurada tu clave SSH localmente
  - El firewall solo permite conexiones SSH desde tu IP actual
  - La instancia tiene Docker y Docker Compose instalados
  EOT
}
