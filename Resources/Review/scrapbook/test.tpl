// This is the description of a template file
// Template description language
// Author: Lixing Huang
// Date: 05/27/2013

{
  // Template Name
  "template_name" : "FirstYear",

  // Define the template page by page
  "pages" : [
    // Cover
    {
      "template_path": "FirstYearTemplateCover.jpg",
      "meta": "cover",
      "elements": [
        {
          "x": 10,
          "y": 20,
          "w": 10,
          "h": 10,
          "radius": 20,
          "type": "text",
          "name": "test1",
        },
        {
          "x": 10,
          "y": 20,
          "w": 10,
          "h": 10,
          "radius": 20,
          "type": "video",
          "name": "test2",
        }
      ]
    },
    // Page 1
    {
      "template_path": "FirstYearTemplateP1.jpg",
      "meta": "page",
      "elements": [
        {
          "x": 10,
          "y": 20,
          "w": 10,
          "h": 10,
          "radius": 20,
          "type": "text",
          "name": "test1",
        },
        {
          "x": 10,
          "y": 20,
          "w": 10,
          "h": 10,
          "radius": 20,
          "type": "video",
          "name": "test2",
        }
      ]
    }
  ]
}