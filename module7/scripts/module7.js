// Event listener for DOMContentLoaded event
document.addEventListener("DOMContentLoaded", function (event) {
  // Event listener for form submission
  document
    .getElementById("orderForm")
    .addEventListener("submit", function (event) {
      event.preventDefault(); // Prevent default form submission

      // Requirement: If and Else
      if (validateForm()) {
        // If form validation passes
        const totalCost = calculateTotal(); // Function call to calculate the total cost
        const shippingCost = getShippingCost(); // Function call to get the shipping cost
        displayReceipt(totalCost, shippingCost); // Function call to display the receipt with total cost and shipping cost
      }
    });

  // Event listener for reset button
  document.getElementById("resetBtn").addEventListener("click", function () {
    document.getElementById("orderForm").reset(); // Reset the form
    resetCheckboxes(); // Function call to reset checkboxes
  });

  // Function to reset checkboxes
  function resetCheckboxes() {
    let checkboxes = document.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach(function (checkbox) {
      checkbox.checked = false; // Uncheck each checkbox
    });
  }
});

// Function to validate the form inputs
function validateForm() {
  // Requirement: Variables
  let firstName = document.getElementById("firstName").value;
  let lastName = document.getElementById("lastName").value;
  let email = document.getElementById("email").value;
  let clothingItemsChecked = document.querySelectorAll(
    'input[type="checkbox"]:checked'
  );
  let shipping = document.querySelector('input[name="shipping"]:checked');

  // Requirement: If and Else
  // Check if any field is empty
  // If - Check if first name field is empty
  if (firstName === "") {
    alert("Please fill in the first name field.");
    return false;
  } else if (lastName === "") {
    // Updated to else if
    alert("Please fill in the last name field.");
    return false;
  } else if (email === "") {
    // Updated to else if
    alert("Please fill in the email field.");
    return false;
  }

  // Requirement: Arrays
  // Check if no clothing items are checked
  if (clothingItemsChecked.length === 0) {
    alert("Please pick at least one clothing item.");
    return false;
  }

  // Requirement: If and Else
  // Check if a shipping option is selected
  if (shipping === null) {
    alert("Please select a shipping option.");
    return false;
  }

  return true;
}

// Function to calculate the total cost
function calculateTotal() {
  let checkboxes = document.querySelectorAll('input[type="checkbox"]');
  let total = 0;
  checkboxes.forEach(function (checkbox) {
    if (checkbox.checked) {
      total += parseFloat(checkbox.value);
    }
  });

  return total.toFixed(2);
}

// Function to get the shipping cost
function getShippingCost() {
  let shippingCost = parseFloat(
    document.querySelector('input[name="shipping"]:checked').value
  );

  return shippingCost.toFixed(2);
}

// Function to display the receipt
function displayReceipt(totalCost, shippingCost) {
  // Calculate the total (sum of total cost and shipping cost)
  const total = (parseFloat(totalCost) + parseFloat(shippingCost)).toFixed(2);

  // Get form input values
  let firstName = document.getElementById("firstName").value;
  let lastName = document.getElementById("lastName").value;
  let email = document.getElementById("email").value;

  // Create a receipt element
  const receiptElement = document.createElement("div");
  receiptElement.classList.add("receipt");

  // Construct the receipt content
  let receiptContent = "<h2>Receipt</h2>";
  receiptContent += "<p><strong>First Name:</strong> " + firstName + "</p>";
  receiptContent += "<p><strong>Last Name:</strong> " + lastName + "</p>";
  receiptContent += "<p><strong>Email:</strong> " + email + "</p>";
  receiptContent += "<p><strong>Total Cost:</strong> $" + totalCost + "</p>";
  receiptContent +=
    "<p><strong>Shipping Cost:</strong> $" + shippingCost + "</p>";
  receiptContent +=
    "<p><strong>Total (incl. shipping):</strong> $" + total + "</p>";

  // Set the receipt content to the receipt element
  receiptElement.innerHTML = receiptContent;

  // Append the receipt element to a container in the HTML, for example:
  const receiptContainer = document.getElementById("receiptContainer");
  receiptContainer.appendChild(receiptElement);
}
