echo "Please enter Project Name"
read projname

# Create project directories
mkdir $projname
cd $projname

# Set up Python environment
sudo apt install python3-pip python3-venv -y
python3 -m venv venv
source venv/bin/activate

# Install Django and create Django project
pip install django
django-admin startproject ${projname}_backend

# Set up frontend with Vite
sudo apt install npm -y
npm create vite@latest ${projname}_frontend
cd ${projname}_frontend
npm install
npm install @mui/material @mui/icons-material

cd ..

# Set up Nginx and SSL
mkdir nginx
cd nginx
sudo apt install openssl -y
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.key -out cert.crt

# Download necessary files
curl -o default.conf https://raw.githubusercontent.com/AmanBasra/Boilerplate/main/nginx/default.conf
curl -o Dockerfile https://raw.githubusercontent.com/AmanBasra/Boilerplate/main/nginx/Dockerfile

# Navigate and clone Dockerfiles
cd ../${projname}_frontend
curl -o Dockerfile https://raw.githubusercontent.com/AmanBasra/Boilerplate/main/React/Dockerfile

cd ../${projname}_backend
curl -o Dockerfile https://raw.githubusercontent.com/AmanBasra/Boilerplate/main/Django/Dockerfile
curl -o entrypoint.sh https://raw.githubusercontent.com/AmanBasra/Boilerplate/main/Django/entrypoint.sh

# Copy SSL files to backend
cp ../nginx/key.key ./
cp ../nginx/cert.crt ./

cd ..
curl -o docker-compose.yaml https://raw.githubusercontent.com/AmanBasra/Boilerplate/main/Docker/docker-compose.yaml
sed -i "s/appname/${projname}/g" ./docker-compose.yaml
