#!/bin/bash

# Vérification des privilèges root
if [ "$EUID" -ne 0 ]; then
    echo "Veuillez exécuter ce script en tant que root ou avec sudo."
    exit
fi

# --------------------------
# Étape 1 : Nettoyage
# --------------------------
echo "Nettoyage des fichiers inutiles..."

# Nettoyage du cache des paquets
echo "Nettoyage du cache des gestionnaires de paquets..."
apt-get clean -y || yum clean all || dnf clean all || echo "Gestionnaire de paquets non reconnu."

# Suppression des fichiers temporaires
echo "Suppression des fichiers temporaires..."
rm -rf /tmp/* /var/tmp/*

# Suppression des anciens journaux
echo "Nettoyage des anciens journaux..."
find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;

echo "Nettoyage terminé."

# --------------------------
# Étape 2 : Mise à jour
# --------------------------
echo "Mise à jour des paquets..."

# Mise à jour des paquets selon le gestionnaire disponible
if command -v apt-get >/dev/null; then
    apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
elif command -v yum >/dev/null; then
    yum update -y && yum autoremove -y
elif command -v dnf >/dev/null; then
    dnf update -y && dnf autoremove -y
else
    echo "Gestionnaire de paquets non reconnu. Veuillez vérifier manuellement."
    exit 1
fi

echo "Mise à jour terminée."

# --------------------------
# Étape 3 : Nettoyage du kernel (optionnel)
# --------------------------
echo "Nettoyage des anciens noyaux..."
if command -v apt-get >/dev/null; then
    apt-get autoremove --purge -y
elif command -v package-cleanup >/dev/null; then
    package-cleanup --oldkernels --count=1 -y
else
    echo "Nettoyage des noyaux non supporté pour ce gestionnaire."
fi

# --------------------------
# Étape 4 : Vérification de l'espace disque
# --------------------------
echo "Vérification de l'espace disque après nettoyage..."
df -h /

echo "Script terminé avec succès."
