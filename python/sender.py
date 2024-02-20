

import serial
import serial.tools.list_ports
import text_uploader as fh
import time


functions=locals
def ports_used():
    list = serial.tools.list_ports.comports()
    print('list')
    connected = []
    print(list)
    for element in list:
        connected.append(element.device)
    print('connected')
    print(connected)
    return connected

def print_ports_used(connected):
    print("Connected COM ports: " + str(connected))
    
def initialize_port(port_name):
    return serial.Serial(port=port_name, baudrate=9600, bytesize=8, timeout=None, stopbits=serial.STOPBITS_ONE)    

def close_port(device_name):
    device_name.close()


def data_string(data_file_name,ext):
    path=fh.current_path()
    folder="data_to_send"
    path='/Users/parkermaner/Hardware_AES_Encryption_Decryption/python/data_to_send/'
    return fh.file_reader(path+data_file_name+"."+ext)

def send_data(data):
    
    FPGA=initialize_port(ports_used()[2])
    print("before sending data: " + str(int(time.time())))
    FPGA.write(data)
    FPGA.write(b'\xff'*16)

    print("after sending data: " + str(int(time.time())))
    close_port(FPGA)
 

def data_fixer(data):
    data=data.encode()
    return data+b'\xff'*(16-len(data)%16)

def data_decoder(data):
    for i in range(len(data)):
        if data[i]==255:
            break
    data=data[:i].decode()
    return data
    
def ascii_data(data):
    try:
        return ([hex(ord(i)) for i in data])
    except:
        data=data_decoder(data)
        return ([hex(ord(i)) for i in data])
        
def send_data_main():   
    filename='data_input'
    ext='txt'
    ports_used_array=ports_used()
    print_ports_used(ports_used_array[0])
    filedata=data_string(filename,ext)
    data=data_fixer(filedata)
    send_data(data)
    print(data)
    print(ascii_data(data))  
    
if __name__ == "__main__":   
    filename='data_input'
    ext='txt'
    ports_used_array=ports_used()
    print_ports_used(ports_used_array[2])
    filedata=data_string(filename,ext)
    #filedata="The art of code"
    data=data_fixer(filedata)
    send_data(data)
    print(data)
    print(ascii_data(data))    
    
    




    
