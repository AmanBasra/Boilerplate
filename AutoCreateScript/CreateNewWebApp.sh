echo "Please enter Project Name"
read projname

# Check for necessary tools
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Install it and re-run the script."
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Install it and re-run the script."
    exit 1
fi

# Create project directories
mkdir $projname
cd $projname

# Set up Python environment
sudo apt install python3-pip python3-venv -y
python3 -m venv venv
source venv/bin/activate

# Install Django and create Django project
pip install django
django-admin startproject ${projname}_backend || { echo "Django project creation failed!" >&2; exit 1; }

# Set up frontend with Vite
sudo apt install npm -y
npm create vite@latest ${projname}_frontend || { echo "Vite project creation failed!" >&2; exit 1; }
cd ${projname}_frontend
npm install

echo "Do you want to install Material-UI? (y/n)"
read mui_install
if [ "$mui_install" == "y" ]; then
    npm install @mui/material @mui/icons-material
fi
cd ..

# Set up Nginx and SSL
mkdir nginx
cd nginx
sudo apt install openssl -y
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.key -out cert.crt

# Download necessary files
curl -o default.conf https://raw.githubusercontent.com/AmanBasra/Boilerplate/main/nginx/default.conf
curl -o Dockerfile https://raw.githubusercontent.com/AmanBasra/Boilerplate/main/nginx/Dockerfile
cd ..

# Clone Dockerfiles
curl -o docker-compose.yaml https://raw.githubusercontent.com/AmanBasra/Boilerplate/main/Docker/docker-compose.yaml
sed -i.bak "s/appname/${projname}/g" ./docker-compose.yaml

cd ${projname}_frontend
curl -o Dockerfile https://raw.githubusercontent.com/AmanBasra/Boilerplate/main/React/Dockerfile
cd ../${projname}_backend
curl -o Dockerfile https://raw.githubusercontent.com/AmanBasra/Boilerplate/main/Django/Dockerfile
curl -o entrypoint