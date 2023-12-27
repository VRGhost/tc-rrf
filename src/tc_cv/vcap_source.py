import asyncio
import threading


class VCapSource(threading.Thread):
    vcap = None
    grabbed = None
    frame = None
    running = False
    frame_counter: int = 0
    lock: threading.Lock

    def __init__(self, vcap):
        super().__init__(name="vcap-thread", daemon=True)
        self.vcap = vcap
        self.running = True
        self.lock = threading.Lock()
        self.start()

    def run(self):
        self.frame_counter = -1
        while self.running:
            (grabbed, frame) = self.vcap.read()
            with self.lock:
                self.grabbed = grabbed
                self.frame = frame
                self.frame_counter += 1
                if self.frame_counter > 10e4:
                    self.frame_counter = 0

    def read(self):
        with self.lock:
            return (self.grabbed, self.frame)

    async def async_read(self):
        old_frame_id = -1
        while True:
            while self.frame_counter < 0 or old_frame_id == self.frame_counter:
                await asyncio.sleep(10e-4)
            yield self.read()
            old_frame_id = self.frame_counter
