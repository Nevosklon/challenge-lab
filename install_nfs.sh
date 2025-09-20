#!/usr/bin/env bash
for i in {0..10}; do
  php /var/www/html/occ app:install files_external || \
    php /var/www/html/occ app:enable files_external
  if [[ "${?}" -ne 0 ]]; then
    sleep 2s
    continue
  fi
  # Create shared directory at /shared/ by default if not set
  php /var/www/html/occ files_external:create  \
    -c "datadir=${SHARED:-/shared/}" -- /share/ local null::null 
  php /var/www/html/occ files:scan --all 
  break
done


