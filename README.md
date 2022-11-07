# Delivery Tracker 1

## Target

You should build an app that keeps track of packages for a user. [Here is a target to match.](https://delivery-tracker-1.matchthetarget.com)

To explore, sign up and create a few deliveries. You can also sign in with any of:

- `alice@example.com`
- `bob@example.com`
- `carol@example.com`
- `dave@example.com`
- `eve@example.com`

and password: `password`.

Behaviors to note:

- You can't do anything in the app until you sign up or sign in.
- The home page has a list of deliveries that you're expecting.
- There are two sections on the home page: "Waiting on" and "Received".
- You can log a new delivery using the form at the top of the page. Once added, it appears in the "Waiting on" section.
- For items in the "Waiting on" section, there is a button that, when clicked, moves the item to the "Received" section.
- For items in the "Received" section, there is a link to delete the item.

## Implementation details that you must stick to:

- As usual, pay attention to the copy in buttons, links, labels, headings, etc — spelling, capitalization, and punctuation matter.
- The sign in page is located at `/user_sign_in`.
- The sign up page is located at `/user_sign_up`.
- The "Waiting on" section should be contained within a `<div>` that has the class `"waiting_on"`.
    - The `background-color` of the "Waiting on" section should be `lightgoldenrodyellow`.
- The "Received" section should be contained within a `<div>` that has the class `"received"`.
    - The `background-color` of the "Received" section should be `lightgreen`.
- For items in the "Waiting on" section, the date that the delivery was expected on is displayed. If the date is more than **3** days ago, the color of the date is `darkred`.

Other notes:

- In the target, the field to enter a date is an `<input type="date">`. This input type may not work properly on all browsers — use Chrome when testing.

All other implementation details are up to you.


---

- check for h2's inside divs
- run through test titles
- order better
- points better
