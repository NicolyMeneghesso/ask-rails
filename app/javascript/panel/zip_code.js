window.clickZipeCode = function () {
  const zipCode = document.getElementById("zip_code").value

  fetch(`/api/zip_code?zip_code=${zipCode}`)
    .then(response => response.json())
    .then(data => {
      if (!data.error) {
        document.getElementById("street").value = data.street;
        document.getElementById("city").value = data.city;
        document.getElementById("state").value = data.state;
      } else {
        alert(data.error);
      }
    });
}

