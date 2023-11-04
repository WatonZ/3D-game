using System;
using FlutterUnityIntegration;
using UnityEngine;
using UnityEngine.EventSystems;
using System.Globalization;

public class movement : MonoBehaviour, IEventSystemHandler
{
    [SerializeField]
    Vector3 Location;
    Vector3 Location1;
    public float speed = 5.0f;
    public float rotationSpeed = 50.0f;
    private Animator animator;


    // Start is called before the first frame update
    void Start()
    {
        Location = new Vector3(0, 0, 0);
        Location1 = new Vector3(0, 0, 0);
        animator = GetComponent<Animator>();

    }

    // Update is called once per frame
    void Update()
    {
        var velocity = Location * speed;
        gameObject.transform.Translate(Location * Time.deltaTime * speed);
        gameObject.transform.Rotate(Location1* Time.deltaTime * rotationSpeed);
        animator.SetFloat("speed", velocity.z);


        for (int i = 0; i < Input.touchCount; ++i)
        {
            if (Input.GetTouch(i).phase.Equals(TouchPhase.Began))
            {
                var hit = new RaycastHit();

                Ray ray = Camera.main.ScreenPointToRay(Input.GetTouch(i).position);

                if (Physics.Raycast(ray, out hit))
                {
                    // This method is used to send data to Flutter
                    UnityMessageManager.Instance.SendMessageToFlutter("The cube feels touched.");
                }
            }
        }
    }

    // This method is called from Flutter
    public void setLocation(String message)
    {
        Debug.Log($"Received flutter message: {message}");
        float value = float.Parse(message, CultureInfo.InvariantCulture.NumberFormat);
        Location = new Vector3(0, 0, -value);
    }
    public void setLocation1(String message)
    {
        Debug.Log($"Received flutter message: {message}");
        float value = float.Parse(message, CultureInfo.InvariantCulture.NumberFormat);
        Location1 = new Vector3(0, value, 0);
    }
}



/*using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class movement : MonoBehaviour
{
    // Start is called before the first frame update

    public float speed = 10.0f;
    public float rotationSpeed = 100.0f;

    void Update()
    {
        // Get the horizontal and vertical axis using arrow keys.
        float translation = Input.GetAxis("Vertical") * speed * Time.deltaTime;
        float rotation = Input.GetAxis("Horizontal") * rotationSpeed * Time.deltaTime;

        // Move translation along the object's z-axis
        transform.Translate(0, 0, translation);
        // Rotate around our y-axis
        transform.Rotate(0, rotation, 0);
    }
}
*/