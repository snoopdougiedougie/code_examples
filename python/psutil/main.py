import psutil

def cpu():
    cpu = str(psutil.cpu_percent())
    print("Current CPU usage is {:s}%".format(cpu))
   
def ram():
    print("*"*10,"RAM Stats","*"*10)
   
    memory = psutil.virtual_memory()
    memory = memory[1]
    print("There is {:n}MB of available RAM".format(memory))
    
def cores():
    physical = psutil.cpu_count(logical=False)
    threads = psutil.cpu_count()
   
    print("This CPU has {:n} cores and {:n} threads".format(physical, threads))
    
def cpuspeed():
    print("*"*10,"CPU Stats","*"*10)
    speed = psutil.cpu_freq([1])
    speed = (speed[0][0])
    print("The CPU speed is {:n} MHz".format(speed))
    
def all():
    cpuspeed()
    cores()
    cpu()
    ram()
    
def main():
    try:
        while True:
            stat = input("Please type 'cpu', 'ram', 'cores', 'cpuspeed'; ENTER to show all stats or CTRL-C ENTER to quit: ")
               
            if stat == "cpu":
                cpu()
            elif stat == "ram":
                ram()
            elif stat == "cores":
                cores()
            elif stat == "cpuspeed":
                cpuspeed()
            else:
               all()
               print()

    except KeyboardInterrupt:
        print("Exiting")
    
if __name__ == '__main__':
  main()