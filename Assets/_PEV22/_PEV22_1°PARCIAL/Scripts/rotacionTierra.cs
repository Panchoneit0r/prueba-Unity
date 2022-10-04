using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rotacionTierra : MonoBehaviour
{
    public Transform planeta;

    public float velocidadRotacion;
    // Start is called before the first frame update
    void Start()
    {
        planeta.GetComponent<Transform>();
    }

    // Update is called once per frame
    void Update()
    {
        planeta.Rotate(new Vector3(0f, velocidadRotacion, 0f), Space.World);
    }
}
