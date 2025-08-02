window.clickZipeCode = async function () {
  const zipCode = document.getElementById("zip_code").value
  try {
    const zipCodeAPI = await fetch(`/api/zip_code?zip_code=${zipCode}`)
    if (!zipCodeAPI.ok) throw new Error('Erro na API')

    const dataZipCode = await zipCodeAPI.json()

    if (dataZipCode.error) {
      alert(dataZipCode.error);
      return;
    }

    document.getElementById("street").value = dataZipCode.address_street;
    document.getElementById("city").value = dataZipCode.address_city;
    document.getElementById("state").value = dataZipCode.address_state;

  } catch (error) {
      console.error('Erro ao buscar as respostas:', error);
   } 
}

